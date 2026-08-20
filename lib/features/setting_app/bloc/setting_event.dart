part of 'setting_bloc.dart';

@freezed
class SettingEvent with _$SettingEvent {
  const factory SettingEvent.onChangeAppLocale(
      {required AppLocaleEnum appLocaleEnum}) = OnChangeAppLocale;
  const factory SettingEvent.onInit() = OnInit;
}
