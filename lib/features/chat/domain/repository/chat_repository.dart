import 'package:base_bloc_3/features/chat/domain/entity/index.dart';
import 'package:base_bloc_3/import.dart';
import 'package:image_picker/image_picker.dart';

abstract class ChatRepo {
  Future<Either<BaseError, List<UserEntity>>> searchUserByUsername(String username);
  Future<Either<BaseError, String>> getOrCreateChatRoom(String targetUid);
  Stream<List<ChatRoomEntity>> getMyChatRooms();
  Future<Either<BaseError, void>> markRoomAsRead(String roomId);
  Stream<List<MessageEntity>> getMessagesStream(String roomId);
  Future<Either<BaseError, void>> sendMessage(String roomId, String content);
  Future<Either<BaseError, UserEntity>> getUserById(String uid);
  Future<Either<BaseError, void>> sendImageMessage({required String roomId, required XFile image});
  Future<Either<BaseError, void>> sendStickerMessage({required String roomId, required String stickerPath});
}
