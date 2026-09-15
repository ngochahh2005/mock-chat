import 'package:base_bloc_3/base/network/errors/error.dart';
import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/chat/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/friends/domain/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

@LazySingleton(as: FriendsRepo)
class FriendsRepositoryImpl implements FriendsRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String get currentUid => _auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> get _users =>
      _firestore.collection('users');

  CollectionReference<Map<String, dynamic>> get _request =>
      _firestore.collection('friends_request');

  CollectionReference<Map<String, dynamic>> get _friendships =>
      _firestore.collection('friendships');

  UserEntity _userFromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserEntity(
      uid: doc.id,
      email: data['email'] as String,
      username: data['username'] as String,
      avatar: data['avatar'] as String,
      displayName: data['displayName'] as String,
    );
  }

  @override
  Future<Either<BaseError, List<UserEntity>>> getAllUsers() async {
    try {
      final snapshot = await _users.get();

      final res = snapshot.docs
          .where((doc) => doc.id != currentUid)
          .map(_userFromDoc)
          .toList();

      return Right(res);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, List<UserEntity>>> getFriends() async {
    try {
      final snapshot =
          await _friendships.where('userIds', arrayContains: currentUid).get();
      final users = <UserEntity>[];
      for (final friendships in snapshot.docs) {
        final data = friendships.data();
        final userIds = List<String>.from(data['userIds'] ?? []);

        final peerId = userIds.firstWhere((id) => id != currentUid);

        final userDoc = await _users.doc(peerId).get();

        if (userDoc.exists) {
          users.add(_userFromDoc(userDoc));
        }
      }

      return Right(users);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, List<UserEntity>>> getIncomingRequest() async {
    try {
      final snapshot = await _request
          .where('receiverId', isEqualTo: currentUid)
          .where('status', isEqualTo: 'pending')
          .get();
      final users = <UserEntity>[];
      for (final request in snapshot.docs) {
        final data = request.data();
        final requesterId = data['requesterId'] as String;
        final userDoc = await _users.doc(requesterId).get();

        if (userDoc.exists) {
          users.add(_userFromDoc(userDoc));
        }
      }

      return Right(users);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, List<UserEntity>>> getOutgoingRequest() async {
    try {
      final snapshot = await _request
          .where('requesterId', isEqualTo: currentUid)
          .where('status', isEqualTo: 'pending')
          .get();
      final users = <UserEntity>[];
      for (final request in snapshot.docs) {
        final data = request.data();
        final receiverId = data['receiverId'] as String;

        final userDoc = await _users.doc(receiverId).get();

        if (userDoc.exists) {
          users.add(_userFromDoc(userDoc));
        }
      }

      return Right(users);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, void>> sendFriendRequest(String peerId) async {
    try {
      final requestId = '${currentUid}_$peerId';
      await _request.doc(requestId).set({
        'requesterId': currentUid,
        'receiverId': peerId,
        'status': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      return const Right(null);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, void>> cancelFriendRequest(String peerId) async {
    try {
      final snapshot = await _request
          .where('requesterId', isEqualTo: currentUid)
          .get();

      final requestDocs = snapshot.docs.where((doc) {
        final data = doc.data();
        return data['receiverId'] == peerId && data['status'] == 'pending';
      });

      for (final requestDoc in requestDocs) {
        await requestDoc.reference.delete();
      }

      return const Right(null);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, void>> acceptFriendRequest(String peerId) async {
    try {
      final requestSnapshot = await _request
          .where('receiverId', isEqualTo: currentUid)
          .get();

      final requestDocs = requestSnapshot.docs.where((doc) {
        final data = doc.data();
        return data['requesterId'] == peerId && data['status'] == 'pending';
      }).toList();

      if (requestDocs.isEmpty) {
        return Left(
          BaseError.httpUnknownError(
            'Không tìm thấy lời mời kết bạn đang chờ xử lý',
          ),
        );
      }

      final requestDoc = requestDocs.first;

      final ids = [currentUid, peerId]..sort();
      final friendshipId = ids.join('_');

      final batch = _firestore.batch();

      batch.update(requestDoc.reference, {'status': 'accepted'});

      batch.set(_friendships.doc(friendshipId), {
        'userIds': ids,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();

      return const Right(null);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }

  @override
  Future<Either<BaseError, void>> removeFriend(String peerId) async {
    try {
      final ids = [currentUid, peerId]..sort();
      final friendshipId = ids.join('_');

      await _friendships.doc(friendshipId).delete();

      return const Right(null);
    } catch (e) {
      return Left(BaseError.httpUnknownError(e.toString()));
    }
  }
}
