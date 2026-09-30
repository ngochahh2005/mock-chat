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
                            final incomingIds = state.incomingRequests
                                .map((user) => user.uid)
                                .toSet();
                            final incoming = users
                                .where((request) =>
                                    incomingIds.contains(request.uid))
                                .toList();

                            final outgoingIds = state.outgoingRequests
                                .map((user) => user.uid)
                                .toSet();
                            final outgoing = users
                                .where((request) =>
                                    outgoingIds.contains(request.uid))
                                .toList();

                            return TabBarView(
                              children: [
                                // friends
                                _buildUsersList(
                                  friendsList,
                                  state,
                                  S.current.no_friends,
                                ),

                                // all
                                _buildUsersList(
                                  users,
                                  state,
                                  S.current.no_friends,
                                ),

                                // requirement
                                _buildRequestsList(
                                  incoming,
                                  outgoing,
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

  Widget _buildRequestsList(
    List<UserEntity> incoming,
    List<UserEntity> outgoing,
    FriendsState state,
    String s,
  ) {
    if (incoming.isEmpty && outgoing.isEmpty) {
      return _ListEmpty(searchKeyword: _searchKeyword);
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        // incoming requests
        if (incoming.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              S.current.friend_requests.toUpperCase(),
              style: const TextStyle(
                color: Color(0xff999999),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _listView(incoming, state, shrinkWrap: true),
        ],

        if (incoming.isNotEmpty && outgoing.isNotEmpty)
          const SizedBox(height: 16),

        // outgoing requests
        if (outgoing.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Divider(
              color: Color(0xffEFEEEE),
              thickness: 4,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              S.current.friend_request_sent.toUpperCase(),
              style: const TextStyle(
                color: Color(0xff999999),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          _listView(outgoing, state, shrinkWrap: true),
        ],
      ],
    );
  }

  // tab friends
  Widget _buildUsersList(
    List<UserEntity> friendsList,
    FriendsState state,
    String s,
  ) {
    if (friendsList.isEmpty) {
      return _ListEmpty(searchKeyword: _searchKeyword);
    }

    return _listView(friendsList, state);
  }

  ListView _listView(List<UserEntity> friendsList, FriendsState state,
      {bool shrinkWrap = false}) {
    return ListView.builder(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
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
                  child: user.avatar == null
                      ? const Icon(Icons.person, color: Colors.white)
                      : ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: user.avatar!,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
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
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}

class _ListEmpty extends StatelessWidget {
  const _ListEmpty({
    super.key,
    required String searchKeyword,
  }) : _searchKeyword = searchKeyword;

  final String _searchKeyword;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_searchKeyword.trim().isEmpty)
            Icon(
              Icons.person_off_sharp,
              color: Color(0xffE1E1E1),
              size: 200,
            )
          else
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  CupertinoIcons.search,
                  size: 200,
                  color: Color(0xffE1E1E1),
                ),
                Positioned(
                  top: 50,
                  left: 50,
                  child: Icon(
                    Icons.clear,
                    weight: 900,
                    size: 70,
                    color: Color(0xffE1E1E1),
                  ),
                ),
              ],
            ),
          Text(
            _searchKeyword.trim().isEmpty
                ? S.current.no_users
                : S.current.no_search_results,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }
}
