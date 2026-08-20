part of 'chat_bloc.dart';

@CopyWith()
class ChatState extends BaseBlocState {
  final List<ChatRoomEntity> rooms;
  final List<UserEntity> searchResults;

  const ChatState({
    required super.status,
    super.message,
    required this.rooms,
    required this.searchResults,
  });

  factory ChatState.init() {
    return const ChatState(
      status: BaseStateStatus.init,
      rooms: [],
      searchResults: [],
    );
  }

  @override
  List get props => [
        status,
        message,
        rooms,
        searchResults,
      ];
}
