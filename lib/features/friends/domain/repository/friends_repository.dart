import 'package:base_bloc_3/features/chat/domain/entity/index.dart';
import 'package:base_bloc_3/import.dart';

abstract class FriendsRepo {
  Future<Either<BaseError, List<UserEntity>>> getAllUsers();
  Future<Either<BaseError, List<UserEntity>>> getFriends();
  Future<Either<BaseError, List<UserEntity>>> getIncomingRequest();
  Future<Either<BaseError, List<UserEntity>>> getOutgoingRequest();
  Future<Either<BaseError, void>> sendFriendRequest(String peerId);
  Future<Either<BaseError, void>> cancelFriendRequest(String peerId);
  Future<Either<BaseError, void>> acceptFriendRequest(String peerId);
  Future<Either<BaseError, void>> removeFriend(String peerId);
}
