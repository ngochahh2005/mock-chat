import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService._();
  static final _instance = SecureStorageService._();
  factory SecureStorageService() => _instance;

  final _storage = FlutterSecureStorage();

  static const _keyUserId = 'auth_uid';
  static const _keyEmail = 'auth_email';
  static const _keyToken = 'access_token';

  Future<void> saveToken({required String token}) async {
    await _storage.read(key: _keyToken);
  }

  Future<void> clearToken() async {
    await _storage.delete(key: _keyToken);
  }

  Future<void> saveUserInfo({required String email, required String uid}) async {
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyUserId, value: uid);
  }

  Future<void> clearUserInfo({required String email, required String uid}) async {
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyEmail);
  }
}