import 'package:flutter/material.dart';

enum AppLocaleEnum {
  english('en', '', 'English'),
  vietnamese('vi', '', 'Tiếng Việt'),
  japanese('ja', '', '日本語');

  final String languageCode;
  final String countryCode;
  final String displayName;

  const AppLocaleEnum(this.languageCode, this.countryCode, this.displayName);

  Locale get locale => Locale(languageCode, countryCode);

  static AppLocaleEnum fromLocale(Locale locale) {
    return AppLocaleEnum.values.firstWhere(
      (e) => e.languageCode == locale.languageCode,
      orElse: () => AppLocaleEnum.english, 
    );
  }


  static AppLocaleEnum fromLanguageCode(String languageCode) {
    return AppLocaleEnum.values.firstWhere(
      (e) => e.languageCode == languageCode,
      orElse: () => AppLocaleEnum.english, 
    );
  }

  @override
  String toString() => displayName;
}
