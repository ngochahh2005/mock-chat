import 'package:base_bloc_3/features/chat/domain/entity/chat_room_entity.dart';
import 'package:base_bloc_3/features/chat/domain/entity/message_entity.dart';
import 'package:base_bloc_3/features/chat/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/chat/domain/repository/chat_repository.dart';
import 'package:base_bloc_3/import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

@LazySingleton(as: ChatRepo)
class ChatRepoImpl with ApiHelperMixin implements ChatRepo {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final SupabaseStorageService _storageService;

  ChatRepoImpl(this._storageService);

  @override
  Future<Either<BaseError, List<UserEntity>>> searchUserByUsername(
    String username,
  ) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: username)
          .where('username', isLessThanOrEqualTo: '$username\uf8ff')
          .get();
      final users = snapshot.docs.map((doc) {
        final data = doc.data();
        return UserEntity(
          uid: doc.id,
          email: data['email'] ?? '',
          username: data['username'] ?? '',
          avatar: data['avatar'],
          displayName: data['displayName'],
        );
      }).toList();

      return Right(users);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, String>> getOrCreateChatRoom(
      String targetUid) async {
    try {
      final currentUid = _auth.currentUser!.uid;
      List<String> ids = [currentUid, targetUid];
      ids.sort();
      final roomId = ids.join('_');

      final roomDoc =
          await _firestore.collection('chat_rooms').doc(roomId).get();
      if (!roomDoc.exists) {
        await _firestore.collection('chat_rooms').doc(roomId).set({
          'members': ids,
          'unreadCounts': {ids[0]: 0, ids[1]: 0},
          'lastMessage': '',
          'lastMessageTime': DateTime.now().toIso8601String(),
        });
      }

      return Right(roomId);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Stream<List<MessageEntity>> getMessagesStream(String roomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(roomId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            final rawCreatedAt = data['createdAt'];
            final createdAt = rawCreatedAt is Timestamp
                ? rawCreatedAt.toDate()
                : DateTime.tryParse(rawCreatedAt?.toString() ?? '') ??
                    DateTime.fromMillisecondsSinceEpoch(0);

            return MessageEntity(
              id: doc.id,
              senderId: data['senderId'] ?? '',
              content: data['content'] ?? '',
              createdAt: createdAt,
              type: data['type'] ?? 'text',
              storagePath: data['storagePath'],
              isRevoked: data['isRevoked'] ?? false,
            );
          }).toList(),
        );
  }

  @override
  Stream<List<ChatRoomEntity>> getMyChatRooms() {
    final currentUid = _auth.currentUser!.uid;
    return _firestore
        .collection('chat_rooms')
        .where('members', arrayContains: currentUid)
        .snapshots()
      .map(
          (snapshot) {
            final rooms = snapshot.docs
                .map(
                  (doc) {
                    final data = doc.data();
                    final unreadCounts = data['unreadCounts'];
                    final unreadCount = unreadCounts is Map
                        ? (unreadCounts[currentUid] as num?)?.toInt() ?? 0
                        : 0;
                    final room = ChatRoomEntity.fromModel(
                      ChatRoomModel.fromJson(data..['id'] = doc.id),
                    );
                    return ChatRoomEntity(
                      id: room.id,
                      members: room.members,
                      lastMessage: room.lastMessage,
                      lastMessageTime: room.lastMessageTime,
                      unreadCount: unreadCount,
                    );
                  },
                )
                .toList();

            rooms.sort((a, b) {
              final aTime = DateTime.tryParse(a.lastMessageTime ?? '') ??
                  DateTime.fromMillisecondsSinceEpoch(0);
              final bTime = DateTime.tryParse(b.lastMessageTime ?? '') ??
                  DateTime.fromMillisecondsSinceEpoch(0);
              return bTime.compareTo(aTime);
            });
            return rooms;
          },
        );
  }

  @override
  Future<Either<BaseError, void>> sendMessage(
      String roomId, String content) async {
    try {
      final senderId = _auth.currentUser!.uid;
      final now = DateTime.now().toIso8601String();

      await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .add({
        'senderId': senderId,
        'type': 'text',
        'content': content,
        'storagePath': null,
        'isRevoked': false,
        'createdAt': now,
      });

      await _incrementUnreadCount(roomId, senderId);
      await _firestore.collection('chat_rooms').doc(roomId).update({
        'lastMessage': content,
        'lastMessageTime': now,
      });

      return const Right(null);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, UserEntity>> getUserById(String uid) async {
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data()!;
        return Right(
          UserEntity(
            uid: uid,
            email: data['email'],
            username: data['username'],
            avatar: data['avatar'],
            displayName: data['displayName'],
          ),
        );
      }
      return Left(BaseError.httpUnknownError(S.current.user_info_not_found));
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, void>> sendImageMessage({
    required String roomId,
    required XFile image,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        return Left(
          BaseError.httpUnknownError(S.current.not_logged_in),
        );
      }

      final storagePath = await _storageService.uploadChatImage(
        image: image,
        roomId: roomId,
        senderUid: user.uid,
      );

      final now = DateTime.now().toIso8601String();

      await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .add({
        'senderId': user.uid,
        'type': 'image',
        'content': '',
        'storagePath': storagePath,
        'isRevoked': false,
        'createdAt': now,
      });

      await _incrementUnreadCount(roomId, user.uid);
      await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .update({
        'lastMessage': '[Hình ảnh]',
        'lastMessageTime': now,
      });

      return const Right(null);
    } catch (e) {
      return Left(
        BaseError.httpUnknownError(e.toString()),
      );
    }
  }

  @override
  Future<Either<BaseError, void>> markRoomAsRead(String roomId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return Left(BaseError.httpUnknownError(S.current.not_logged_in));
      await _firestore.collection('chat_rooms').doc(roomId).update({
        'unreadCounts.${user.uid}': 0,
      });
      return const Right(null);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  Future<void> _incrementUnreadCount(String roomId, String senderId) async {
    final room = await _firestore.collection('chat_rooms').doc(roomId).get();
    final members = List<String>.from(room.data()?['members'] ?? const <String>[]);
    final recipientId = members.firstWhere((id) => id != senderId, orElse: () => '');
    if (recipientId.isNotEmpty) {
      await _firestore.collection('chat_rooms').doc(roomId).update({
        'unreadCounts.$recipientId': FieldValue.increment(1),
      });
    }
  }

  @override
  Future<Either<BaseError, void>> sendStickerMessage({
    required String roomId,
    required String stickerPath,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        return Left(BaseError.httpUnknownError(S.current.not_logged_in));
      }
      final now = DateTime.now().toIso8601String();
      await _firestore
          .collection('chat_rooms')
          .doc(roomId)
          .collection('messages')
          .add({
        'senderId': user.uid,
        'type': 'sticker',
        'content': '',
        'storagePath': stickerPath,
        'isRevoked': false,
        'createdAt': now,
      });
      await _incrementUnreadCount(roomId, user.uid);
      await _firestore.collection('chat_rooms').doc(roomId).update({
        'lastMessage': '[Sticker]',
        'lastMessageTime': now,
      });
      return const Right(null);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }
}
