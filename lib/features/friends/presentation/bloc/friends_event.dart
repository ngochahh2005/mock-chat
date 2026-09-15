part of 'friends_bloc.dart';

@freezed
class FriendsEvent with _$FriendsEvent {
  const factory FriendsEvent.loadData() = _LoadData;
  const factory FriendsEvent.sendRequest(String peerId) = _SendRequest;
  const factory FriendsEvent.cancelRequest(String peerId) = _CancelRequest;
  const factory FriendsEvent.acceptRequest(String peerId) = _AcceptRequest;
  const factory FriendsEvent.removeFriend(String peerId) = _RemoveFriend;
}
