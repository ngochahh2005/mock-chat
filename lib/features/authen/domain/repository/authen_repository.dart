import 'package:base_bloc_3/import.dart';
import 'dart:io';

abstract class AuthenRepository {
  Future<Either<BaseError, String>> login(String email, String password);
  Future<Either<BaseError, void>> register(String email, String password, String username);
  Future<Either<BaseError, void>> logout();
  Future<Either<BaseError, Map<String, dynamic>>> fetchProfile();
  Future<Either<BaseError, void>> updateProfile(String? username, File? avatarFile, String? displayName);
}
