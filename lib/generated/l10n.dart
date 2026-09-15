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

  /// `Please verify your email to log in!`
  String get verify_email_to_login {
    return Intl.message(
      'Please verify your email to log in!',
      name: 'verify_email_to_login',
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

  /// `Policies`
  String get policy {
    return Intl.message('Policies', name: 'policy', desc: '', args: []);
  }

  /// `Message`
  String get message {
    return Intl.message('Message', name: 'message', desc: '', args: []);
  }

  /// `Friends`
  String get friends {
    return Intl.message('Friends', name: 'friends', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `You are not logged in!`
  String get not_logged_in {
    return Intl.message(
      'You are not logged in!',
      name: 'not_logged_in',
      desc: '',
      args: [],
    );
  }

  /// `This email is already used by another account!`
  String get email_already_in_use {
    return Intl.message(
      'This email is already used by another account!',
      name: 'email_already_in_use',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email format!`
  String get invalid_email {
    return Intl.message(
      'Invalid email format!',
      name: 'invalid_email',
      desc: '',
      args: [],
    );
  }

  /// `No account found with this email!`
  String get user_not_found {
    return Intl.message(
      'No account found with this email!',
      name: 'user_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect password!`
  String get wrong_password {
    return Intl.message(
      'Incorrect password!',
      name: 'wrong_password',
      desc: '',
      args: [],
    );
  }

  /// `Invalid email or password!`
  String get invalid_credential {
    return Intl.message(
      'Invalid email or password!',
      name: 'invalid_credential',
      desc: '',
      args: [],
    );
  }

  /// `This account has been disabled!`
  String get user_disabled {
    return Intl.message(
      'This account has been disabled!',
      name: 'user_disabled',
      desc: '',
      args: [],
    );
  }

  /// `Too many failed attempts. Please try again later.`
  String get too_many_requests {
    return Intl.message(
      'Too many failed attempts. Please try again later.',
      name: 'too_many_requests',
      desc: '',
      args: [],
    );
  }

  /// `Network connection error. Please check your 3G/Wifi.`
  String get network_request_failed {
    return Intl.message(
      'Network connection error. Please check your 3G/Wifi.',
      name: 'network_request_failed',
      desc: '',
      args: [],
    );
  }

  /// `Please enter both email and password.`
  String get channel_error {
    return Intl.message(
      'Please enter both email and password.',
      name: 'channel_error',
      desc: '',
      args: [],
    );
  }

  /// `Login failed. Error code:`
  String get error_message {
    return Intl.message(
      'Login failed. Error code:',
      name: 'error_message',
      desc: '',
      args: [],
    );
  }

  /// `User information not found!`
  String get user_info_not_found {
    return Intl.message(
      'User information not found!',
      name: 'user_info_not_found',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Notification`
  String get notification {
    return Intl.message(
      'Notification',
      name: 'notification',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message('Logout', name: 'logout', desc: '', args: []);
  }

  /// `App version`
  String get app_version {
    return Intl.message('App version', name: 'app_version', desc: '', args: []);
  }

  /// `Edit information`
  String get edit_info {
    return Intl.message(
      'Edit information',
      name: 'edit_info',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `No chats yet!`
  String get no_chats {
    return Intl.message('No chats yet!', name: 'no_chats', desc: '', args: []);
  }

  /// `No chats yet!`
  String get no_chat {
    return Intl.message('No chats yet!', name: 'no_chat', desc: '', args: []);
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `No messages yet!`
  String get no_message {
    return Intl.message(
      'No messages yet!',
      name: 'no_message',
      desc: '',
      args: [],
    );
  }

  /// `Terms`
  String get terms {
    return Intl.message('Terms', name: 'terms', desc: '', args: []);
  }

  /// `By registering and using our chat application, you agree to comply with these terms. You are solely responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account. The application strictly prohibits spamming, phishing, distributing malware, harassment, or sharing any illegal content. We reserve the right to suspend or permanently terminate your account without prior notice if any violation is detected. These terms may be updated periodically, and your continued use of the app constitutes your acceptance of such changes.`
  String get content_terms {
    return Intl.message(
      'By registering and using our chat application, you agree to comply with these terms. You are solely responsible for maintaining the confidentiality of your login credentials and for all activities that occur under your account. The application strictly prohibits spamming, phishing, distributing malware, harassment, or sharing any illegal content. We reserve the right to suspend or permanently terminate your account without prior notice if any violation is detected. These terms may be updated periodically, and your continued use of the app constitutes your acceptance of such changes.',
      name: 'content_terms',
      desc: '',
      args: [],
    );
  }

  /// `We are committed to protecting your privacy. All your personal data and message contents are securely encrypted on our systems. The application only collects information necessary to maintain its functionality, authenticate accounts, and improve user experience. We strictly do not sell, trade, or share your personal information with any third parties for commercial purposes without your explicit consent.`
  String get content_policy {
    return Intl.message(
      'We are committed to protecting your privacy. All your personal data and message contents are securely encrypted on our systems. The application only collects information necessary to maintain its functionality, authenticate accounts, and improve user experience. We strictly do not sell, trade, or share your personal information with any third parties for commercial purposes without your explicit consent.',
      name: 'content_policy',
      desc: '',
      args: [],
    );
  }

  /// `Enter message...`
  String get enter_message {
    return Intl.message(
      'Enter message...',
      name: 'enter_message',
      desc: '',
      args: [],
    );
  }

  /// `Today`
  String get today {
    return Intl.message('Today', name: 'today', desc: '', args: []);
  }

  /// `Yesterday`
  String get yesterday {
    return Intl.message('Yesterday', name: 'yesterday', desc: '', args: []);
  }

  /// `Search username...`
  String get search_username {
    return Intl.message(
      'Search username...',
      name: 'search_username',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load stickers`
  String get sticker_load_error {
    return Intl.message(
      'Unable to load stickers',
      name: 'sticker_load_error',
      desc: '',
      args: [],
    );
  }

  /// `No stickers available`
  String get no_stickers {
    return Intl.message(
      'No stickers available',
      name: 'no_stickers',
      desc: '',
      args: [],
    );
  }

  /// `Unable to load messages`
  String get chat_load_error {
    return Intl.message(
      'Unable to load messages',
      name: 'chat_load_error',
      desc: '',
      args: [],
    );
  }

  /// `Saved successfully!`
  String get save_success {
    return Intl.message(
      'Saved successfully!',
      name: 'save_success',
      desc: '',
      args: [],
    );
  }

  /// `All`
  String get all {
    return Intl.message('All', name: 'all', desc: '', args: []);
  }

  /// `Requests`
  String get requests {
    return Intl.message('Requests', name: 'requests', desc: '', args: []);
  }

  /// `Friend requests`
  String get friend_requests {
    return Intl.message(
      'Friend requests',
      name: 'friend_requests',
      desc: '',
      args: [],
    );
  }

  /// `Accept`
  String get accept {
    return Intl.message('Accept', name: 'accept', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Request sent`
  String get request_sent {
    return Intl.message(
      'Request sent',
      name: 'request_sent',
      desc: '',
      args: [],
    );
  }

  /// `Search friends`
  String get search_friends {
    return Intl.message(
      'Search friends',
      name: 'search_friends',
      desc: '',
      args: [],
    );
  }

  /// `Add friend`
  String get add_friend {
    return Intl.message('Add friend', name: 'add_friend', desc: '', args: []);
  }

  /// `Unfriend`
  String get unfriend {
    return Intl.message('Unfriend', name: 'unfriend', desc: '', args: []);
  }

  String get no_users {
    return Intl.message('No users yet', name: 'no_users', desc: '', args: []);
  }

  String get no_search_results {
    return Intl.message(
      'No users found',
      name: 'no_search_results',
      desc: '',
      args: [],
    );
  }

  String get no_friends {
    return Intl.message(
      'No friends yet',
      name: 'no_friends',
      desc: '',
      args: [],
    );
  }

  String get no_friend_results {
    return Intl.message(
      'No results found',
      name: 'no_friend_results',
      desc: '',
      args: [],
    );
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
