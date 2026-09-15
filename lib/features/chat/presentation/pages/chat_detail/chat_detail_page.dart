import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/chat/domain/entity/index.dart';
import 'package:base_bloc_3/features/chat/domain/repository/chat_repository.dart';
import 'package:base_bloc_3/features/chat/presentation/pages/widget/chat_tab_bar.dart';
import 'package:base_bloc_3/features/chat/presentation/pages/widget/get_message_position.dart';
import 'package:base_bloc_3/features/chat/presentation/pages/widget/message_frame.dart';
import 'package:base_bloc_3/features/chat/presentation/pages/widget/peer_avatar.dart';
import 'package:base_bloc_3/features/chat/presentation/pages/widget/send_time.dart';
import 'package:base_bloc_3/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ChatDetailPage extends StatefulWidget {
  final String roomId;
  final UserEntity peerInfo;

  const ChatDetailPage(
      {super.key, required this.roomId, required this.peerInfo});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    getIt<ChatRepo>().markRoomAsRead(widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    return BaseScaffold(
      backgroundColor: Color(0xffF6F6F6),
      appBar: AppBar(
        toolbarHeight: 44,
        titleSpacing: 0,
        backgroundColor: Color(0xffF6F6F6),
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            CupertinoIcons.back,
            color: Color(0xff4356B4),
          ),
        ),
        title: Row(
          spacing: 18,
          children: [
            PeerAvatar(widget: widget),
            Text(
              widget.peerInfo.displayName!,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 16),
        padding: EdgeInsets.only(top: 18, left: 12, right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<MessageEntity>>(
                stream: getIt<ChatRepo>().getMessagesStream(widget.roomId),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        S.of(context).chat_load_error,
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final messages = snapshot.data ?? [];
                  if (messages.isEmpty) {
                    return Center(child: Text(S.current.no_message));
                  }
                  return ListView.separated(
                    reverse: true,
                    itemCount: messages.length + 1,
                    itemBuilder: (context, i) {
                      if (i == messages.length) {
                        return _DateSeparator(date: messages.last.createdAt);
                      }
                      final isMe = messages[i].senderId == currentUid;
                      final position = getMessageGroupPosition(messages, i);
                      return Align(
                        alignment:
                            isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: !isMe
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 2,
                                children: [
                                  Row(
                                    spacing: 4,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      if ((position ==
                                              MessageGroupPosition.single ||
                                          position ==
                                              MessageGroupPosition.bottom))
                                        PeerAvatar(widget: widget)
                                      else
                                        SizedBox(
                                          height: 44,
                                          width: 44,
                                        ),
                                      MessageFrame(
                                        isMe: isMe,
                                        position: position,
                                        message: messages[i],
                                      ),
                                    ],
                                  ),
                                  if (position == MessageGroupPosition.single ||
                                      position == MessageGroupPosition.bottom)
                                    Padding(
                                      padding: EdgeInsets.only(left: 48),
                                      child: SendTime(message: messages[i]),
                                    ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                spacing: 2,
                                children: [
                                  MessageFrame(
                                    isMe: isMe,
                                    position: position,
                                    message: messages[i],
                                  ),
                                  if (position == MessageGroupPosition.bottom ||
                                      position == MessageGroupPosition.single)
                                    SendTime(message: messages[i]),
                                ],
                              ),
                      );
                    },
                    separatorBuilder: (context, i) {
                      if (i == messages.length - 1) {
                        return const SizedBox(height: 2);
                      }
                      final current = messages[i].createdAt.toLocal();
                      final next = messages[i + 1].createdAt.toLocal();
                      if (DateUtils.isSameDay(current, next)) {
                        return const SizedBox(height: 2);
                      }
                      return _DateSeparator(date: current);
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: ChatTabBar(
                controller: _controller,
                focusNode: _focusNode,
                widget: widget,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }
}

class _DateSeparator extends StatelessWidget {
  final DateTime date;

  const _DateSeparator({required this.date});

  String _label(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final value = DateTime(date.year, date.month, date.day);
    if (value == today) {
      return S.of(context).today;
    }
    if (value == today.subtract(const Duration(days: 1))) {
      return S.of(context).yesterday;
    }

    return DateFormat('dd MMM', locale.toLanguageTag()).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xffF1F1F4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _label(context),
          style: const TextStyle(
            color: Color(0xff777783),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
