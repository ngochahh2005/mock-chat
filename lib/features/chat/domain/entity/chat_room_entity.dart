import 'package:base_bloc_3/data/index.dart';

class ChatRoomEntity {
  final String id;
  final List<String> members;
  final String? lastMessage;
  final String? lastMessageTime;
  final int unreadCount;

  ChatRoomEntity({
    required this.id,
    required this.members,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory ChatRoomEntity.fromModel(ChatRoomModel chatRoomModel) {
    return ChatRoomEntity(
      id: chatRoomModel.id,
      members: chatRoomModel.members,
      lastMessage: chatRoomModel.lastMessage,
      lastMessageTime: chatRoomModel.lastMessageTime,
    );
  }
}
