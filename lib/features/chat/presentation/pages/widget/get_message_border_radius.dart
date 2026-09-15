import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/chat/presentation/pages/widget/get_message_position.dart';

BorderRadius getMessageBorderRadius({
  required MessageGroupPosition position,
  required bool isMe,
}) {
  const big = Radius.circular(30);

  if (isMe) {
    switch (position) {
      case MessageGroupPosition.single:
        return const BorderRadius.all(big);
      case MessageGroupPosition.bottom:
        return const BorderRadius.only(
          topLeft: big,
          bottomLeft: big,
          bottomRight: big,
        );
      case MessageGroupPosition.top:
        return const BorderRadius.only(
          topLeft: big,
          topRight: big,
          bottomLeft: big,
        );
      case MessageGroupPosition.middle:
        return const BorderRadius.only(
          topLeft: big,
          bottomLeft: big,
        );
    }
  } else {
    switch (position) {
      case MessageGroupPosition.single:
        return const BorderRadius.all(big);
      case MessageGroupPosition.bottom:
        return const BorderRadius.only(
          topRight: big,
          bottomRight: big,
          bottomLeft: big,
        );
      case MessageGroupPosition.top:
        return const BorderRadius.only(
          topLeft: big,
          topRight: big,
          bottomRight: big,
        );
      case MessageGroupPosition.middle:
        return const BorderRadius.only(
          topRight: big,
          bottomRight: big,
        );
    }
  }
}
