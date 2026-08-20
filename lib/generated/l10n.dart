// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Hello`
  String get title {
    return Intl.message('Hello', name: 'title', desc: '', args: []);
  }

  /// `Welcome to my app!`
  String get greeting {
    return Intl.message(
      'Welcome to my app!',
      name: 'greeting',
      desc: '',
      args: [],
    );
  }

  /// `An unknown error occurred.`
  String get error_unknown {
    return Intl.message(
      'An unknown error occurred.',
      name: 'error_unknown',
      desc: '',
      args: [],
    );
  }

  /// `Failed to connect to server, please try again`
  String get dio_cancel_request {
    return Intl.message(
      'Failed to connect to server, please try again',
      name: 'dio_cancel_request',
      desc: '',
      args: [],
    );
  }

  /// `Failed to connect to server, please try again`
  String get dio_connect_timeout {
    return Intl.message(
      'Failed to connect to server, please try again',
      name: 'dio_connect_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Failed to connect to server, please try again`
  String get dio_cancel_other {
    return Intl.message(
      'Failed to connect to server, please try again',
      name: 'dio_cancel_other',
      desc: '',
      args: [],
    );
  }

  /// `Failed to connect to server, please try again`
  String get dio_receive_timeout {
    return Intl.message(
      'Failed to connect to server, please try again',
      name: 'dio_receive_timeout',
      desc: '',
      args: [],
    );
  }

  /// `Failed to connect to server, please try again`
  String get dio_send_timeout {
    return Intl.message(
      'Failed to connect to server, please try again',
      name: 'dio_send_timeout',
      desc: '',
      args: [],
    );
  }

  /// `An error occurred, please try again later`
  String get error_system {
    return Intl.message(
      'An error occurred, please try again later',
      name: 'error_system',
      desc: '',
      args: [],
    );
  }

  /// `No internet access, please check your internet connection`
  String get no_internet_access {
    return Intl.message(
      'No internet access, please check your internet connection',
      name: 'no_internet_access',
      desc: '',
      args: [],
    );
  }

  /// `Click to reload`
  String get click_to_reload {
    return Intl.message(
      'Click to reload',
      name: 'click_to_reload',
      desc: '',
      args: [],
    );
  }

  /// `Invalid OTP.`
  String get invalid_otp {
    return Intl.message(
      'Invalid OTP.',
      name: 'invalid_otp',
      desc: '',
      args: [],
    );
  }

  /// `Not found.`
  String get not_found {
    return Intl.message('Not found.', name: 'not_found', desc: '', args: []);
  }

  /// `Message displayed when the user is denied permission`
  String get permission_denied {
    return Intl.message(
      'Message displayed when the user is denied permission',
      name: 'permission_denied',
      desc: '',
      args: [],
    );
  }

  /// `Welcome back`
  String get welcome_back {
    return Intl.message(
      'Welcome back',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Login to your account`
  String get login_to_your_account {
    return Intl.message(
      'Login to your account',
      name: 'login_to_your_account',
      desc: '',
      args: [],
    );
  }

  /// `Username`
  String get username {
    return Intl.message('Username', name: 'username', desc: '', args: []);
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Login`
  String get login {
    return Intl.message('Login', name: 'login', desc: '', args: []);
  }

  /// `Don't have an account?`
  String get do_not_have_an_account {
    return Intl.message(
      'Don\'t have an account?',
      name: 'do_not_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message('Register', name: 'register', desc: '', args: []);
  }

  /// `Signup`
  String get signup {
    return Intl.message('Signup', name: 'signup', desc: '', args: []);
  }

  /// `Email`
  String get Email {
    return Intl.message('Email', name: 'Email', desc: '', args: []);
  }

  /// `Create your account`
  String get create_your_account {
    return Intl.message(
      'Create your account',
      name: 'create_your_account',
      desc: '',
      args: [],
    );
  }

  /// `Confirm Password`
  String get confirm_password {
    return Intl.message(
      'Confirm Password',
      name: 'confirm_password',
      desc: '',
      args: [],
    );
  }

  /// `Registered Successfully`
  String get registered_successfully {
    return Intl.message(
      'Registered Successfully',
      name: 'registered_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get already_have_an_account {
    return Intl.message(
      'Already have an account?',
      name: 'already_have_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Home Screen`
  String get home_screen {
    return Intl.message('Home Screen', name: 'home_screen', desc: '', args: []);
  }

  /// `Page Not Found`
  String get page_not_found {
    return Intl.message(
      'Page Not Found',
      name: 'page_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Can't find a page for: {uri}`
  String page_not_found_message(Object uri) {
    return Intl.message(
      'Can\'t find a page for: $uri',
      name: 'page_not_found_message',
      desc: '',
      args: [uri],
    );
  }

  /// `Please enter username.`
  String get validators_username_required {
    return Intl.message(
      'Please enter username.',
      name: 'validators_username_required',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password.`
  String get validators_password_required {
    return Intl.message(
      'Please enter password.',
      name: 'validators_password_required',
      desc: '',
      args: [],
    );
  }

  /// `Password must be at least 6 characters long.`
  String get validators_password_min_length {
    return Intl.message(
      'Password must be at least 6 characters long.',
      name: 'validators_password_min_length',
      desc: '',
      args: [],
    );
  }

  /// `Please enter email.`
  String get validators_email_required {
    return Intl.message(
      'Please enter email.',
      name: 'validators_email_required',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email.`
  String get validators_email_invalid {
    return Intl.message(
      'Invalid email.',
      name: 'validators_email_invalid',
      desc: '',
      args: [],
    );
  }

  /// `Please enter password.`
  String get validators_password_confirmation_required {
    return Intl.message(
      'Please enter password.',
      name: 'validators_password_confirmation_required',
      desc: '',
      args: [],
    );
  }

  /// `Password doesn't match.`
  String get validators_password_confirmation_mismatch {
    return Intl.message(
      'Password doesn\'t match.',
      name: 'validators_password_confirmation_mismatch',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Experience Awesome Chat`
  String get experience_app {
    return Intl.message(
      'Experience Awesome Chat',
      name: 'experience_app',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get forgot_password {
    return Intl.message(
      'Forgot password?',
      name: 'forgot_password',
      desc: '',
      args: [],
    );
  }

  /// `Full name`
  String get full_name {
    return Intl.message('Full name', name: 'full_name', desc: '', args: []);
  }

  /// `I agree with the `
  String get agree_with {
    return Intl.message(
      'I agree with the ',
      name: 'agree_with',
      desc: '',
      args: [],
    );
  }

  /// `policies`
  String get policy {
    return Intl.message('policies', name: 'policy', desc: '', args: []);
  }

  /// `regulations`
  String get regulation {
    return Intl.message('regulations', name: 'regulation', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
