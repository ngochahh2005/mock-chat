part of 'auth_bloc.dart';

@CopyWith()
class AuthState extends BaseBlocState {
  final bool isLogin;
  final bool isLoginSuccess;
  final bool isRegisterSuccess;
  final bool isLogoutSuccess;

  const AuthState({
    required super.status,
    super.message,
    required this.isLogin,
    required this.isLoginSuccess,
    required this.isRegisterSuccess,
    required this.isLogoutSuccess,
  });

  factory AuthState.init() {
    return const AuthState(
      status: BaseStateStatus.init,
      isLogin: false,
      isLoginSuccess: false,
      isRegisterSuccess: false,
      isLogoutSuccess: false,
    );
  }

  @override
  List get props => [status, message, isLogin, isLoginSuccess, isRegisterSuccess, isLogoutSuccess];
}
