import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultConfig {
  static String get getBaseUrl => dotenv.get('BASE_URL');
}

class PasswordConfig {
  static const int maxLength = 8;
  static const int minLength = 8;
  static const int minimumRuleMatch = 3;
}
