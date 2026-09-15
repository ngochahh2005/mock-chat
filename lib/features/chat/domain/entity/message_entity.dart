import 'package:base_bloc_3/data/index.dart';

enum MessageType {
  text,
  image,
  sticker,
}

class MessageEntity {
  final String id;
  final String senderId;
  final String content;
  final DateTime createdAt;
  final String type;
  final String? storagePath;
  final bool isRevoked;

  MessageEntity({
    required this.id,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.type,
    this.storagePath,
    this.isRevoked = false,
  });

  factory MessageEntity.fromModel(MessageModel model) {
    return MessageEntity(
      id: model.id ?? '',
      senderId: model.senderId ?? '',
      content: model.content ?? '',
      createdAt: DateTime.parse(model.createdAt ?? ''),
      type: MessageType.text.name,
    );
  }
}
