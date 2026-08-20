import 'package:base_bloc_3/common/external_lib.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/features/chat/domain/entity/message_entity.dart';
import 'package:base_bloc_3/features/chat/domain/repository/chat_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatDetailPage extends StatefulWidget {
  final String roomId;
  final String peerName;
  const ChatDetailPage({super.key, required this.roomId, required this.peerName});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    return Scaffold(
      appBar: AppBar(title: Text(widget.peerName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageEntity>>(
              stream: getIt<ChatRepo>().getMessagesStream(widget.roomId),
              builder: (context, snapshot) {
                final messages = snapshot.data ?? [];
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, i) {
                    final isMe = messages[i].senderId == currentUid;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.blue : Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(messages[i].content, style: TextStyle(color: isMe ? Colors.white : Colors.black)),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      getIt<ChatRepo>().sendMessage(widget.roomId, _controller.text);
                      _controller.clear();
                    }
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}