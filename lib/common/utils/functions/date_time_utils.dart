// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

enum Pattern {
  hhmm,
  ddMMMMyyyyHHmm,
  ddMMyyyy,
  hhmmEEEEddMMyyyy,
  hhmma,
  EEEE,
}

extension PatternExtension on Pattern {
  String get pattern {
    switch (this) {
      case Pattern.hhmm:
        return 'HH:mm';
      case Pattern.ddMMMMyyyyHHmm:
        return 'dd/MMMM/yyyy HH:mm';
      case Pattern.ddMMyyyy:
        return 'dd/MM/yyyy';
      case Pattern.hhmmEEEEddMMyyyy:
        return 'HH:mm, EEEE dd/MM/yyyy';
      case Pattern.hhmma:
        return 'hh:mm a';
      case Pattern.EEEE:
        return 'EEEE';
      default:
        return '';
    }
  }
}

const secondMillis = 1000;
const minuteMillis = 60 * secondMillis;
const hourMillis = 60 * minuteMillis;
const dayMillis = 24 * hourMillis;
const weekMillis = 7 * dayMillis;
const minuteSecond = 60;
const hourSecond = 60 * minuteSecond;
const monthMillis = 31 * dayMillis;
const quarterMillis = 3 * monthMillis;

DateTime? getDateTime(dynamic dateToConvert, {Pattern? pattern}) {
  if (dateToConvert is int) {
    return DateTime.fromMillisecondsSinceEpoch(dateToConvert);
  } else if (dateToConvert is String) {
    return DateFormat(pattern!.pattern).parse(dateToConvert);
  }
  return null;
}

String getStringDate(
  dynamic dateToConvert,
  Pattern pattern, {
  String? languageCode,
}) {
  if (dateToConvert == null) {
    return '';
  }

  final dateFormat = DateFormat(pattern.pattern, languageCode);
  if (dateToConvert is int) {
    final datetime = getDateTime(dateToConvert);
    return dateFormat.format(datetime!);
  } else if (dateToConvert is DateTime) {
    return dateFormat.format(dateToConvert.toLocal());
  }
  return '';
}

int getTimestamp(dynamic dateToConvert, Pattern pattern) {
  if (dateToConvert is DateTime) {
    return dateToConvert.millisecondsSinceEpoch;
  } else if (dateToConvert is String) {
    final dateFormat = DateFormat(pattern.pattern);
    return dateFormat.parse(dateToConvert).millisecondsSinceEpoch;
  }
  return 0;
}

DateTime? getDateFromDateAndTime({
  dynamic date,
  String? time,
  required Pattern pattern,
}) {
  if (date == null || time == null) {
    return null;
  }
  if (date is String) {
    return getDateTime('$date $time', pattern: pattern);
  } else if (date is DateTime) {
    return getDateTime(
      '${getStringDate(date, Pattern.ddMMyyyy)} $time',
      pattern: Pattern.ddMMyyyy,
    );
  }
  return null;
}
