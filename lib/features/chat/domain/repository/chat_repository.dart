import 'package:base_bloc_3/features/chat/domain/entity/index.dart';
import 'package:base_bloc_3/import.dart';

abstract class ChatRepo {
  Future<Either<BaseError, List<UserEntity>>> searchUserByUsername(String username);
  Future<Either<BaseError, String>> getOrCreateChatRoom(String targetUid);
  Stream<List<ChatRoomEntity>> getMyChatRooms();
  Stream<List<MessageEntity>> getMessagesStream(String roomId);
  Future<Either<BaseError, void>> sendMessage(String roomId, String content);
  Future<Either<BaseError, UserEntity>> getUserById(String uid);
}
