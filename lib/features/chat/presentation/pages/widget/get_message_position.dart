import 'package:base_bloc_3/features/chat/domain/entity/index.dart';

enum MessageGroupPosition {
  single,
  top,
  middle,
  bottom,
}

bool isSameGroup(MessageEntity a, MessageEntity b) {
  if (a.senderId != b.senderId || a.type != b.type) return false;
  final difference = a.createdAt.difference(b.createdAt).abs();
  return difference <= const Duration(minutes: 1);
}

MessageGroupPosition getMessageGroupPosition(
  List<MessageEntity> messages,
  int index,
) {
  final cur = messages[index];

  final hasNewer = index > 0;
  final hasOlder = index < messages.length - 1;

  final sameWithNewer = hasNewer && isSameGroup(cur, messages[index - 1]);
  final sameWithOlder = hasOlder && isSameGroup(cur, messages[index + 1]);

  if (!sameWithOlder && !sameWithNewer) return MessageGroupPosition.single;

  if (!sameWithOlder && sameWithNewer) {
    return MessageGroupPosition.top;
  }

  if (sameWithOlder && sameWithNewer) {
    return MessageGroupPosition.middle;
  }

  return MessageGroupPosition.bottom;
}
