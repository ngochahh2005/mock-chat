part of 'chat_bloc.dart';

@CopyWith()
class ChatState extends BaseBlocState {
  final List<ChatRoomEntity> rooms;
  final List<UserEntity> searchResults;
  final Map<String, UserEntity> users;

  const ChatState({
    required super.status,
    super.message,
    required this.rooms,
    required this.searchResults,
    required this.users,
  });

  factory ChatState.init() {
    return const ChatState(
      status: BaseStateStatus.init,
      rooms: [],
      searchResults: [],
      users: {},
    );
  }

  @override
  List get props => [
        status,
        message,
        rooms,
        searchResults,
        users,
      ];
}
