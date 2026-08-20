part of 'setting_bloc.dart';

@CopyWith()
class SettingState extends BaseBlocState {
  final AppLocaleEnum appLocale;

  const SettingState({
    required super.status,
    super.message,
    required this.appLocale,
  });

  factory SettingState.init() {
    return const SettingState(
      status: BaseStateStatus.init,
      appLocale: AppLocaleEnum.english,
    );
  }

  @override
  List get props => [status, message, appLocale];
}
