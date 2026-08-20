import 'package:base_bloc_3/features/setting_app/enum/app_locale_enum.dart';
import 'package:base_bloc_3/import.dart';

part 'setting_bloc.freezed.dart';
part 'setting_bloc.g.dart';
part 'setting_event.dart';
part 'setting_state.dart';

@lazySingleton
class SettingBloc extends BaseBloc<SettingEvent, SettingState> {
  final LocalStorage _localStorage = getIt<LocalStorage>();
  SettingBloc() : super(SettingState.init()) {
    on<SettingEvent>((SettingEvent event, Emitter<SettingState> emit) async {
      await event.when(
        onChangeAppLocale: (AppLocaleEnum appLocaleEnum) =>
            _onChangeAppLocale(emit, appLocaleEnum),
        onInit: () => _onInit(emit),
      );
    });
  }

  _onChangeAppLocale(
    Emitter<SettingState> emit,
    AppLocaleEnum appLocaleEnum,
  ) {
    emit(state.copyWith(appLocale: appLocaleEnum));
    _localStorage.save(SharePrefConstants.languageCode, appLocaleEnum.languageCode);
  }

  _onInit(Emitter<SettingState> emit) async {
    final languageCode = await _localStorage.get(SharePrefConstants.languageCode) ??
        AppLocaleEnum.english.languageCode;
    final appLocale = AppLocaleEnum.fromLanguageCode(languageCode);
    emit(state.copyWith(appLocale: appLocale));
  }
}
