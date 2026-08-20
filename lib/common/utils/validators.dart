import 'package:base_bloc_3/import.dart';

class Validators {
  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.validators_username_required;
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.validators_password_required;
    }
    if (value.length < 6) {
      return S.current.validators_password_min_length;
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.validators_email_required;
    } else if (!(value.contains('@') && value.contains('.'))) {
      return S.current.validators_email_invalid;
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return S.current.validators_password_confirmation_required;
    } else if (value != password) {
      return S.current.validators_password_confirmation_mismatch;
    }
    return null;
  }
}
