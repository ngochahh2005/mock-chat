extension StringExtension on String? {
  static const int validatePhoneLength = 10;
  static const int maxLengthPrefixEmail = 64;
  static const int maxLengthSuffixEmail = 255;

  bool get isValidEmail {
    if (this == null || this!.isEmpty) return false;
    return RegExp(
        r"^(?=.{1,254}$)(?=.{1,64}@)[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+[A-Za-z]{2,63}$",
        ).hasMatch(this!.trim()) &&
        isValidLengthEmail;
  }

  bool get isValidLengthEmail {
    if (this == null || this!.isEmpty) return false;
    if (this!.contains("@")) {
      return this!.trim().split("@")[0].length <= maxLengthPrefixEmail &&
          this!.trim().split("@")[1].length <= maxLengthSuffixEmail;
    } else {
      return false;
    }
  }

  bool get isValidFormatEmail {
    if (this == null || this!.isEmpty) return false;
    return RegExp(
        r"^(?=.{1,254}$)(?=.{1,64}@)[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[A-Za-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[A-Za-z0-9](?:[A-Za-z0-9-]{0,61}[A-Za-z0-9])?\.)+[A-Za-z]{2,63}$",
    ).hasMatch(this!.trim());
  }

  bool get isValidPhone {
    if (this == null) return false;
    return RegExp(
          r'^(0?)(3[2-9]|5[6|8|9]|7[0|6-9]|8[0-6|8|9]|9[0-4|6-9])[0-9]{7}$',
        ).hasMatch(this!.trim()) &&
        this!.trim().length == validatePhoneLength;
  }

  bool get isRestrictedEmoji {
    return RegExp(
      '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    ).hasMatch(this!);
  }
}

extension StringNonNullableExtension on String {
  String useCorrectEllipsis() {
    return replaceAll('', '\u200B');
  }

  String replaceParams({required Map<String, String> params}) {
    String result = this;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }

  String get formatEmptyStringDate => isEmpty ? '----/--/-- ()' : this;
  String get formatEmptyStringDateTime =>
      isEmpty ? '----/--/-- ()\n-- : --' : this;
}

extension OptionalStringExtension on String? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }

  bool isNotNullOrEmpty() {
    return !isNullOrEmpty();
  }
}
