import 'package:base_bloc_3/features/chat/index.dart';
import 'package:base_bloc_3/features/friends/domain/repository/friends_repository.dart';
import 'package:base_bloc_3/import.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CreateChatPage extends StatefulWidget {
  const CreateChatPage({super.key});

  @override
  State<CreateChatPage> createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> {
  final TextEditingController _searchController = TextEditingController();
  late final Future<Either<BaseError, List<UserEntity>>> _usersFuture;

  String _searchKeyword = '';
  UserEntity? _selectedUser;
  bool _isOpeningChat = false;

  @override
  void initState() {
    super.initState();
    _usersFuture = getIt<FriendsRepo>().getFriends();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff4356B4), Color(0xff3DCFCF)],
          stops: [0, 0.2],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(CupertinoIcons.back, color: Colors.white),
          ),
          title: Text(
            S.current.create_message,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child:
                  Text(S.current.cancel, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: TextField(
                controller: _searchController,
                cursorColor: const Color(0xff4356B4),
                onChanged: (value) => setState(
                  () => _searchKeyword = value.trim().toLowerCase(),
                ),
                decoration: InputDecoration(
                  hintText: S.current.search_friends,
                  hintStyle: const TextStyle(color: Color(0xff999999)),
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: Color(0xff4356B4),
                  ),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _searchKeyword = '');
                          },
                          icon: const Icon(Icons.clear, color: Colors.grey),
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Material(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                clipBehavior: Clip.antiAlias,
                child: FutureBuilder<Either<BaseError, List<UserEntity>>>(
                  future: _usersFuture,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: SpinKitFadingCircle(
                          color: Color(0xff4356B4),
                        ),
                      );
                    }

                    final users = snapshot.data!.fold<List<UserEntity>>(
                      (_) => <UserEntity>[],
                      (items) => items.where((user) {
                        if (_searchKeyword.isEmpty) return true;
                        return user.nameDisplay.toLowerCase().contains(
                                  _searchKeyword,
                                ) ||
                            user.username.toLowerCase().contains(
                                  _searchKeyword,
                                );
                      }).toList(),
                    );

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(16, 20, 16, 4),
                          child: Text(
                            S.current.friend_list,
                            style: TextStyle(
                              color: Color(0xff999999),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            itemCount: users.length,
                            separatorBuilder: (_, __) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                height: 0.5,
                                indent: 75,
                                color: Color(0xffD2D2D2),
                              ),
                            ),
                            itemBuilder: (context, index) {
                              final user = users[index];
                              final isSelected = _selectedUser?.uid == user.uid;
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                onTap: () => setState(
                                  () =>
                                      _selectedUser = isSelected ? null : user,
                                ),
                                leading: Container(
                                  width: 50.w,
                                  height: 50.h,
                                  alignment: Alignment.center,
                                  child: CustomUserAvatar(
                                    avatarUrl: user.avatar,
                                  ),
                                ),
                                title: Text(
                                  user.nameDisplay,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                trailing: Icon(
                                  isSelected
                                      ? CupertinoIcons.check_mark_circled_solid
                                      : CupertinoIcons.circle,
                                  color: isSelected
                                      ? const Color(0xff4356B4)
                                      : const Color(0xff989898),
                                  size: 25,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: _selectedUser == null
            ? null
            : SafeArea(
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 8, 16, 12),
                  color: Color(0xffF6F6F6),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          CustomUserAvatar(
                            avatarUrl: _selectedUser!.avatar,
                            size: 56,
                          ),
                          Positioned(
                            right: -5,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedUser = null;
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                width: 18.w,
                                height: 18.h,
                                child: const Center(
                                  child: Icon(
                                    Icons.clear,
                                    size: 16,
                                    color: Color(0xff4356B4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      FloatingActionButton(
                        heroTag: 'create-chat-next',
                        backgroundColor: const Color(0xff4356B4),
                        shape: CircleBorder(),
                        onPressed: _isOpeningChat ? null : _openChat,
                        child: Center(
                          child: _isOpeningChat
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: SpinKitFadingCircle(
                                    color: Colors.white,
                                    size: 22,
                                  ),
                                )
                              : const Icon(
                                  CupertinoIcons.right_chevron,
                                  color: Colors.white,
                                  size: 35,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> _openChat() async {
    final user = _selectedUser;
    if (user == null) return;

    setState(() => _isOpeningChat = true);
    final result = await getIt<ChatRepo>().getOrCreateChatRoom(user.uid);
    if (!mounted) return;

    result.fold(
      (error) {
        setState(() => _isOpeningChat = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      },
      (roomId) {
        context.push(
          RouteName.chatDetail,
          extra: {'roomId': roomId, 'peerInfo': user},
        );
      },
    );
  }
}
