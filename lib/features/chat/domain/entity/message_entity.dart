import 'package:base_bloc_3/data/index.dart';

class MessageEntity {
  final String id;
  final String senderId;
  final String content;
  final String createdAt;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
  });

  factory MessageEntity.fromModel(MessageModel model) {
    return MessageEntity(
      id: model.id ?? '',
      senderId: model.senderId ?? '',
      content: model.content ?? '',
      createdAt: model.createdAt ?? '',
    );
  }
}
