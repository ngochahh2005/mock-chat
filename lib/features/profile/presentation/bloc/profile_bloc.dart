import 'package:base_bloc_3/features/authen/domain/repository/authen_repository.dart';
import 'package:base_bloc_3/features/profile/domain/repository/profile_repository.dart';
import 'package:base_bloc_3/import.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'profile_bloc.freezed.dart';

part 'profile_bloc.g.dart';

part 'profile_event.dart';

part 'profile_state.dart';

@injectable
class ProfileBloc extends BaseBloc<ProfileEvent, ProfileState> {
  final AuthenRepository _repo;

  ProfileBloc(this._repo) : super(ProfileState.init()) {
    on<ProfileEvent>((ProfileEvent event, Emitter<ProfileState> emit) async {
      await event.when(
        fetchProfile: () => _onFetchProfile(emit),
        updateProfile: (username, avatarFile, displayName) =>
            _onUpdateProfile(emit, username, avatarFile, displayName),
        toggleNotification: (isEnable) => _onToggleNotification(emit, isEnable),
      );
    });
  }

  Future<void> _onFetchProfile(Emitter<ProfileState> emit) async {
    final res = await _repo.fetchProfile();
    final user = FirebaseAuth.instance.currentUser!;

    res.fold(
      (error) => emit(state.copyWith(status: BaseStateStatus.failed)),
      (data) {
        final avatar = data['avatar'] ?? user.photoURL;
        emit(
          state.copyWith(
            status: BaseStateStatus.success,
            username: data['username'],
            email: data['email'],
            avatarUrl: avatar,
            displayName: user.displayName,
          ),
        );
      }
    );
  }

  Future<void> _onUpdateProfile(
    Emitter<ProfileState> emit,
    String? username,
    File? avatarFile,
    String? displayName,
  ) async {
    emit(state.copyWith(status: BaseStateStatus.loading));
    final res = await _repo.updateProfile(username, avatarFile, displayName);
    res.fold(
      (error) => emit(state.copyWith(status: BaseStateStatus.failed)),
      (_) => emit(
        state.copyWith(
          status: BaseStateStatus.success,
          username: username,
          displayName: displayName,
        ),
      ),
    );
    add(const ProfileEvent.fetchProfile());
  }

  Future<void> _onToggleNotification(
    Emitter<ProfileState> emit,
    bool isEnable,
  ) async {

  }
}
