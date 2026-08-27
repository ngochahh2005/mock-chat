part of 'profile_bloc.dart';

@CopyWith()
class ProfileState extends BaseBlocState {
  const ProfileState({
    required super.status,
    super.message,
    required this.email,
    this.username,
    this.avatarUrl,
    this.displayName,
    this.isNotificationEnabled = true,
  });

  final String email;
  final String? username;
  final String? avatarUrl;
  final String? displayName;
  final bool isNotificationEnabled;

  factory ProfileState.init() {
    return const ProfileState(
      status: BaseStateStatus.init,
      email: '',
    );
  }

  @override
  List get props => [
        status,
        message,
        email,
        username,
        avatarUrl,
        displayName,
        isNotificationEnabled,
      ];
}
