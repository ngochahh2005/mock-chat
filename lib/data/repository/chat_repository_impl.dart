import 'package:base_bloc_3/features/chat/domain/entity/chat_room_entity.dart';
import 'package:base_bloc_3/features/chat/domain/entity/message_entity.dart';
import 'package:base_bloc_3/features/chat/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/chat/domain/repository/chat_repository.dart';
import 'package:base_bloc_3/import.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

@LazySingleton(as: ChatRepo)
class ChatRepoImpl with ApiHelperMixin implements ChatRepo {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  ChatRepoImpl();

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
          password: '',
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
            return MessageEntity(
                id: doc.id,
                senderId: data['senderId'] ?? '',
                content: data['content'] ?? '',
                createdAt: data['createdAt'] ?? '');
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
          (snapshot) => snapshot.docs
              .map(
                (doc) => ChatRoomEntity.fromModel(
                  ChatRoomModel.fromJson(doc.data()..['id'] = doc.id),
                ),
              )
              .toList(),
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
        'content': content,
        'createdAt': now,
      });

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
  Future<Either<BaseError, UserEntity>> getUserById(String uid) {
    // TODO: implement getUserById
    throw UnimplementedError();
  }
}
