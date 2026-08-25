import 'package:base_bloc_3/features/chat/domain/repository/chat_repository.dart';
import 'package:base_bloc_3/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:base_bloc_3/features/chat/widget/search_username_text_field.dart';
import 'package:base_bloc_3/import.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

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
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff4356B4),
            Color(0xff3DCFCF),
          ],
          stops: [
            0,
            0.2,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            S.current.message,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Icon(
                          CupertinoIcons.chat_bubble_text_fill,
                          color: Color(0xff4356B4),
                        ),
                      ),
                      Positioned(
                        right: 3,
                        top: 3,
                        child: Icon(
                          Icons.add,
                          color: Color(0xff4356B4),
                          size: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: SearchUsernameTextField(bloc: bloc),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
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
                                .getOrCreateChatRoom(
                                    state.searchResults[i].uid);
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
                    return ListView.separated(
                      itemCount: state.rooms.length,
                      itemBuilder: (context, i) {
                        final room = state.rooms[i];
                        return ListTile(
                          leading:
                              const CircleAvatar(child: Icon(Icons.person)),
                          title: Text(
                            "Phòng: ${room.id.split('_').firstWhere((id) => id != FirebaseAuth.instance.currentUser?.uid)}",
                          ),
                          subtitle:
                              Text(room.lastMessage ?? "Chưa có tin nhắn"),
                          onTap: () {
                            final peerId = room.members.firstWhere(
                              (id) =>
                                  id != FirebaseAuth.instance.currentUser?.uid,
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
                      }, separatorBuilder: (context, index) => Divider(
                      height: 1,
                      thickness: 2,
                      indent: 75,
                      endIndent: 16,
                      color: Color(0xffD2D2D2),
                    ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
