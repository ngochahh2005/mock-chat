import 'package:base_bloc_3/features/chat/domain/repository/chat_repository.dart';
import 'package:base_bloc_3/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:base_bloc_3/features/chat/widget/search_username_text_field.dart';
import 'package:base_bloc_3/import.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

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
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                clipBehavior: Clip.antiAlias,
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

                    if (state.rooms.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 18,
                          children: [
                            Icon(
                              CupertinoIcons.chat_bubble_2_fill,
                              color: Color(0xffd2d2d2),
                              size: 100,
                            ),
                            Text(
                              S.of(context).no_chat,
                              style: TextStyle(
                                fontSize: 24.h,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return ListView.separated(
                        itemCount: state.rooms.length,
                        itemBuilder: (context, i) {
                          final room = state.rooms[i];
                          final myUid = FirebaseAuth.instance.currentUser?.uid;
                          final peerId = room.members.firstWhere(
                            (id) => id != myUid,
                            orElse: () => myUid ?? '',
                          );
                          final peerInfo = state.users[peerId];
                          final time = DateTime.parse(
                            room.lastMessageTime ?? '',
                          ).toLocal();
                          final now = DateTime.now();
                          final locale = Localizations.localeOf(context);
                          final lastestMessageTime = DateUtils.isSameDay(
                            time,
                            now,
                          )
                              ? DateFormat('HH:mm', locale.toLanguageTag())
                                  .format(time)
                              : (time.year == now.year)
                                  ? DateFormat('dd MMM', locale.toLanguageTag())
                                      .format(time)
                                  : DateFormat(
                                          'dd MMM yyyy', locale.toLanguageTag())
                                      .format(time);
                          return InkWell(
                            onTap: () {
                              context.push(
                                RouteName.chatDetail,
                                extra: {
                                  'roomId': room.id,
                                  'peerInfo': peerInfo,
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Row(
                                children: [
                                  // avatar
                                  SizedBox(
                                    height: 68,
                                    width: 68,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: [
                                        if (room.unreadCount > 0)
                                          Container(
                                            height: 68,
                                            width: 68,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: const Color(0xff4356B4),
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                        Container(
                                          height: 56,
                                          width: 56,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xff4356B4),
                                                Color(0xff3DCFCF),
                                              ],
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                            ),
                                          ),
                                          child: peerInfo?.avatar != null
                                              ? ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: peerInfo!.avatar!,
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                              : const Center(
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        if (room.unreadCount > 0)
                                          Positioned(
                                            right: -8,
                                            top: -4,
                                            child: Container(
                                              constraints: const BoxConstraints(
                                                minWidth: 28,
                                                minHeight: 28,
                                              ),
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xffD32F2F),
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 3,
                                                ),
                                              ),
                                              alignment: Alignment.center,
                                              child: Text(
                                                room.unreadCount > 99
                                                    ? '99+'
                                                    : '${room.unreadCount}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 12),

                                  // name + lastest message
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // name
                                        peerInfo?.nameDisplay == null
                                            ? Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Text(
                                            S.current.loading,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        )
                                            : Text(
                                          peerInfo!.nameDisplay!,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),

                                        // lastest message
                                        Text(
                                          room.lastMessage ?? S.current.no_message,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // lastest message time
                                  Text(
                                    lastestMessageTime,
                                    style: const TextStyle(
                                      color: Color(0xff999999),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Divider(
                            height: 0.5,
                            thickness: 1,
                            indent: 95,
                            endIndent: 16,
                            color: Color(0xffD2D2D2),
                          ),
                        ),
                      );
                    }
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
