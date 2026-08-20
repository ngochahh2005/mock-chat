part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.onAuthStarted() = OnAuthStarted;
  const factory AuthEvent.onLoginEvent({required String email, required String password}) = OnLoginEvent;
  const factory AuthEvent.onRegisterEvent({required String email, required String password, required String username}) = OnRegisterEvent;
  const factory AuthEvent.onLogoutEvent() = OnLogoutEvent;
}
