import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/features/chat/domain/entity/message_entity.dart';
import 'package:intl/intl.dart';

class SendTime extends StatelessWidget {
  const SendTime({
    super.key,
    required this.message,
  });

  final MessageEntity message;

  @override
  Widget build(BuildContext context) {
    return Text(
      DateFormat('HH:mm').format(message.createdAt),
      style: TextStyle(
        fontSize: 12,
        color: Color(0xff999999),
      ),
    );
  }
}