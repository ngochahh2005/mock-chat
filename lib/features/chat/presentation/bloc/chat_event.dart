part of 'chat_bloc.dart';

@freezed
class ChatEvent with _$ChatEvent {
  const factory ChatEvent.fetchMyRooms() = _FetchMyRooms;
  const factory ChatEvent.searchUser(String username) = _SearchUser;
  const factory ChatEvent.clearSearch() = _ClearSearch;
}
