import 'package:base_bloc_3/features/chat/domain/repository/chat_repository.dart';
import 'package:base_bloc_3/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:base_bloc_3/import.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState
    extends BaseState<ChatPage, ChatEvent, ChatState, ChatBloc> {
  @override
  void initState() {
    super.initState();
    bloc.add(const ChatEvent.fetchMyRooms());
  }

  @override
  Widget renderUI(BuildContext context) {
    return BaseScaffold(
      appBar: BaseAppBar(title: "Tin nhắn"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Tìm kiếm username...",
                prefixIcon: const Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (val) => bloc.add(ChatEvent.searchUser(val)),
            ),
          ),
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state.searchResults.isNotEmpty) {
                  return ListView.builder(
                    itemCount: state.searchResults.length,
                    itemBuilder: (context, i) => ListTile(
                      title: Text(state.searchResults[i].username),
                      subtitle: Text(state.searchResults[i].email),
                      onTap: () async {
                        final res = await getIt<ChatRepo>()
                            .getOrCreateChatRoom(state.searchResults[i].uid);
                        await res.fold((_) => null, (roomId) {
                          context.push(
                            RouteName.chatDetail,
                            extra: {
                              'roomId': roomId,
                              'peerName': state.searchResults[i].username,
                            },
                          );
                        });
                      },
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.rooms.length,
                  itemBuilder: (context, i) {
                    final room = state.rooms[i];
                    return ListTile(
                      leading: const CircleAvatar(child: Icon(Icons.person)),
                      title: Text(
                          "Phòng: ${room.id.split('_').firstWhere((id) => id != FirebaseAuth.instance.currentUser?.uid)}"),
                      subtitle: Text(room.lastMessage ?? "Chưa có tin nhắn"),
                      onTap: () {
                        final peerId = room.members.firstWhere(
                          (id) => id != FirebaseAuth.instance.currentUser?.uid,
                        );
                        context.push(
                          RouteName.chatDetail,
                          extra: {
                            'roomId': room.id,
                            'peerName': 'User $peerId',
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
