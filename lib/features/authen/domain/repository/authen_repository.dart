import 'package:base_bloc_3/import.dart';

abstract class AuthenRepository {
  Future<Either<BaseError, String>> login(String email, String password);
  Future<Either<BaseError, void>> register(String email, String password, String username);
  Future<Either<BaseError, void>> logout();
}
