part of 'profile_bloc.dart';

@freezed
class ProfileEvent with _$ProfileEvent {
  const factory ProfileEvent.fetchProfile() = _FetchProfile;

  const factory ProfileEvent.updateProfile({
    String? username,
    File? avatarFile,
    String? displayName,
  }) = _UpdateProfile;

  const factory ProfileEvent.toggleNotification(bool isEnable) =
      _ToggleNotification;
}
