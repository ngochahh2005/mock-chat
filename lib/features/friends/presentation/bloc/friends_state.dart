part of 'friends_bloc.dart';

@CopyWith()
class FriendsState extends BaseBlocState {
  final List<UserEntity> users;
  final List<UserEntity> friends;
  final List<UserEntity> incomingRequests;
  final List<UserEntity> outgoingRequests;

  const FriendsState({
    required super.status,
    super.message,
    required this.users,
    required this.friends,
    required this.incomingRequests,
    required this.outgoingRequests,
  });

  factory FriendsState.init() {
    return const FriendsState(
      status: BaseStateStatus.init,
      users: [],
      friends: [],
      incomingRequests: [],
      outgoingRequests: [],
    );
  }

  @override
  List get props => [
        status,
        message,
        users,
        friends,
        incomingRequests,
        outgoingRequests,
      ];
}
