import 'package:base_bloc_3/features/authen/domain/repository/authen_repository.dart';
import 'package:base_bloc_3/import.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_bloc.freezed.dart';

part 'auth_bloc.g.dart';

part 'auth_event.dart';

part 'auth_state.dart';

@lazySingleton
class AuthBloc extends BaseBloc<AuthEvent, AuthState> {
  final AuthenRepository _authRepository = getIt<AuthenRepository>();
  final LocalStorage _localStorage = getIt<LocalStorage>();

  AuthBloc() : super(AuthState.init()) {
    on<AuthEvent>((AuthEvent event, Emitter<AuthState> emit) async {
      await event.when(
        onAuthStarted: () => _onStarted(emit),
        onLoginEvent: (email, password) =>
            _onLoginStarted(emit, email, password),
        onRegisterEvent: (email, password, username) =>
            _onRegisterStarted(emit, email, password, username),
        onLogoutEvent: () => _onAuthLogoutStarted(emit),
      );
    });
  }

  Future<void> _onStarted(Emitter<AuthState> emit) async {
    // FirebaseAuth restores its persisted session automatically. Do not use
    // the cached ID token as the login flag because Firebase ID tokens expire
    // and are refreshed internally while the session remains valid.
    final user = await FirebaseAuth.instance.authStateChanges().first;
    if (user != null && user.emailVerified) {
      emit(
        state.copyWith(
          isLogin: true,
          status: BaseStateStatus.success,
          isLogoutSuccess: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          isLogin: false,
          status: BaseStateStatus.success,
          isLogoutSuccess: false,
        ),
      );
    }
  }

  Future<void> _onLoginStarted(
    Emitter<AuthState> emit,
    String email,
    String password,
  ) async {
    emit(
      state.copyWith(status: BaseStateStatus.loading, isLoginSuccess: false),
    );

    final resp = await _authRepository.login(email, password);
    await resp.fold((error) {
      final errorMessage = error.when(
        httpInternalServerError: (body) => body,
        httpUnAuthorizedError: () => "Phiên đăng nhập hết hạn",
        httpUnknownError: (msg) => msg,
      );
      emit(
        state.copyWith(
          status: BaseStateStatus.failed,
          message: errorMessage,
          isLoginSuccess: false,
        ),
      );
    }, (token) async {
      await _localStorage.save(SharePrefConstants.accessToken, token);

      emit(
        state.copyWith(
          status: BaseStateStatus.success,
          isLogin: true,
          isLoginSuccess: true,
          isLogoutSuccess: false,
        ),
      );
    });
  }

  Future<void> _onRegisterStarted(
    Emitter<AuthState> emit,
    String email,
    String password,
    String username,
  ) async {
    emit(
      state.copyWith(
        status: BaseStateStatus.loading,
        isRegisterSuccess: false,
      ),
    );

    final resp = await _authRepository.register(email, password, username);

    await resp.fold((error) {
      emit(
        state.copyWith(
          status: BaseStateStatus.failed,
          message: error.toString(),
          isRegisterSuccess: false,
        ),
      );
    }, (_) {
      emit(
        state.copyWith(
          status: BaseStateStatus.success,
          isRegisterSuccess: true,
        ),
      );
    });
  }

  Future<void> _onAuthLogoutStarted(
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    await _localStorage.remove(SharePrefConstants.accessToken);
    await _localStorage.remove(SharePrefConstants.refreshToken);
    emit(state.copyWith(isLogoutSuccess: true, isLogin: false));
  }

}
