import 'package:base_bloc_3/features/chat/domain/entity/user_entity.dart';
import 'package:base_bloc_3/features/friends/presentation/bloc/friends_bloc.dart';
import 'package:base_bloc_3/import.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState
    extends BaseState<FriendsPage, FriendsEvent, FriendsState, FriendsBloc>
    with TickerProviderStateMixin {
  String _searchKeyword = '';

  @override
  void initState() {
    super.initState();
    bloc.add(const FriendsEvent.loadData());
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
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [
            0,
            0.2,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            S.current.friends,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          actions: [
            GestureDetector(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                height: 35.h,
                width: 35.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Center(
                  child: Icon(
                    Icons.person_add_alt_sharp,
                    color: Color(0xff4356B4),
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            // search friend text field
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: TextField(
                cursorColor: const Color(0xff4356B4),
                decoration: InputDecoration(
                  hintText: S.current.search_friends,
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff999999),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: Color(0xff4356B4),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchKeyword = value;
                  });
                },
              ),
            ),

            // body
            Expanded(
              child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                ),
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      // tab bar
                      TabBar(
                        isScrollable: false,
                        tabAlignment: TabAlignment.fill,
                        labelColor: const Color(0xff4356B4),
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        unselectedLabelColor: const Color(0xff999999),
                        tabs: [
                          Tab(
                            text: S.current.friends.toUpperCase(),
                          ),
                          Tab(
                            text: S.current.all.toUpperCase(),
                          ),
                          Tab(
                            text: S.current.requests.toUpperCase(),
                          ),
                        ],
                      ),

                      Expanded(
                        child: BlocBuilder<FriendsBloc, FriendsState>(
                          bloc: bloc,
                          builder: (context, state) {
                            final keyword = _searchKeyword.trim().toLowerCase();
                            final users = state.users.where((user) {
                              if (keyword.isEmpty) return true;

                              final username = user.username.toLowerCase();
                              final displayName =
                                  user.displayName?.toLowerCase() ?? '';

                              return username.contains(keyword) ||
                                  displayName.contains(keyword);
                            }).toList();

                            final friendsList = users
                                .where((u) =>
                                    state.friends.any((f) => f.uid == u.uid))
                                .toList();
                            final requestIds = {
                              ...state.incomingRequests.map((user) => user.uid),
                              ...state.outgoingRequests.map((user) => user.uid),
                            };
                            final requestsList = users
                                .where((user) => requestIds.contains(user.uid))
                                .toList();

                            if (users.isEmpty) {
                              return Center(
                                child: Text(
                                  _searchKeyword.trim().isEmpty
                                      ? S.current.no_users
                                      : S.current.no_search_results,
                                ),
                              );
                            }

                            return TabBarView(
                              children: [
                                _buildUsersList(
                                  friendsList,
                                  state,
                                  S.current.no_friends,
                                ),
                                _buildUsersList(
                                  users,
                                  state,
                                  S.current.no_friends,
                                ),
                                _buildUsersList(
                                  requestsList,
                                  state,
                                  S.current.no_friends,
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // tab friends
  Widget _buildUsersList(
      List<UserEntity> friendsList, FriendsState state, String s) {
    if (friendsList.isEmpty) {
      return Center(
        child:
            Text(
              _searchKeyword.trim().isEmpty
                  ? s
                  : S.current.no_friend_results,
            ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 8),
      itemCount: friendsList.length,
      itemBuilder: (context, index) {
        final user = friendsList[index];

        final isFriend = state.friends.any((f) => f.uid == user.uid);
        final hasOutgoingRequest =
            state.outgoingRequests.any((r) => r.uid == user.uid);
        final hasIncomingRequest =
            state.incomingRequests.any((r) => r.uid == user.uid);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SizedBox(
            height: 56,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: const Color(0xff4356B4),
                  backgroundImage:
                      user.avatar != null ? NetworkImage(user.avatar!) : null,
                  child: user.avatar == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.nameDisplay,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        '@${user.username}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  width: 88,
                  height: 40,
                  child: _buildActionButton(
                    user,
                    isFriend,
                    hasOutgoingRequest,
                    hasIncomingRequest,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(
      UserEntity user, bool isFriend, bool hasOutgoing, bool hasIncoming) {
    return ValueListenableBuilder<Set<String>>(
      valueListenable: bloc.processingIds,
      builder: (context, processingIds, child) {
        final isLoading = processingIds.contains(user.uid);

        if (isLoading) {
          return SizedBox(
            width: 82,
            height: 30,
            child: Center(
              child: SpinKitThreeInOut(
                color: const Color(0xff4356B4),
                size: 17,
              ),
            ),
          );
        }

        if (isFriend) {
          return OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xffC92323),
              fixedSize: const Size(82, 30),
              padding: EdgeInsets.zero,
              side: const BorderSide(color: Color(0xffC92323)),
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              bloc.add(FriendsEvent.removeFriend(user.uid));
            },
            child: Text(
              S.current.unfriend,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          );
        }

        if (hasIncoming) {
          return FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xff4356B4),
              fixedSize: const Size(82, 30),
              padding: EdgeInsets.zero,
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              bloc.add(FriendsEvent.acceptRequest(user.uid));
            },
            child: Text(
              S.current.accept,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          );
        }

        if (hasOutgoing) {
          return OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xff4356B4),
              fixedSize: const Size(82, 30),
              padding: EdgeInsets.zero,
              side: const BorderSide(color: Color(0xff4356B4)),
              shape: const StadiumBorder(),
            ),
            onPressed: () {
              bloc.add(FriendsEvent.cancelRequest(user.uid));
            },
            child: Text(
              S.current.cancel,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          );
        }

        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xff4356B4),
            fixedSize: const Size(82, 30),
            padding: EdgeInsets.zero,
            shape: const StadiumBorder(),
          ),
          onPressed: () {
            bloc.add(FriendsEvent.sendRequest(user.uid));
          },
          child: Text(
            S.current.add_friend,
            style: TextStyle(fontSize: 12),
          ),
        );
      },
    );
  }
}
