import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/data/service/supabase_storage/supabase_storage_service.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/chat/domain/entity/message_entity.dart';
import 'package:base_bloc_3/features/chat/presentation/pages/widget/get_message_border_radius.dart';
import 'package:base_bloc_3/features/chat/presentation/pages/widget/get_message_position.dart';
import 'package:flutter/cupertino.dart';

class MessageFrame extends StatelessWidget {
  const MessageFrame({
    super.key,
    required this.isMe,
    required this.position,
    required this.message,
  });

  final bool isMe;
  final MessageGroupPosition position;
  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    if ((message.type == MessageType.image.name || message.type == MessageType.sticker.name) &&
        message.storagePath != null &&
        !message.isRevoked) {
      final storageService = getIt<SupabaseStorageService>();
      final imageUrl = message.type == MessageType.sticker.name
          ? storageService.getStickerUrl(message.storagePath!)
          : storageService.getImageUrl(message.storagePath!);

      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: message.type == MessageType.sticker.name ? 180 : 220,
          height: message.type == MessageType.sticker.name ? 180 : 220,
          fit: message.type == MessageType.sticker.name ? BoxFit.contain : BoxFit.cover,
          placeholder: (context, url) => Container(
            width: message.type == MessageType.sticker.name ? 180 : 220,
            height: message.type == MessageType.sticker.name ? 180 : 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Color(0xffF6F6F6),
            ),
            child: Icon(
              CupertinoIcons.photo,
              color: Color(0xff999999),
              size: 100,
            ),
          ),
          errorWidget: (context, url, error) {
            return const Icon(Icons.broken_image);
          },
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.all(1),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isMe ? Color(0xff4356B4) : Color(0xffF6F6F6),
        borderRadius: getMessageBorderRadius(
          position: position,
          isMe: isMe,
        ),
      ),
      child: Text(
        !message.isRevoked ? message.content : 'Tin nhắn đã được thu hồi',
        style: TextStyle(
          color: isMe ? Colors.white : Colors.black,
          fontSize: 16,
        ),
      ),
    );
  }
}
