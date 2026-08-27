import 'package:base_bloc_3/data/index.dart';

class UserEntity {
  final String uid;
  final String email;
  final String username;
  final String password;
  final String? avatar;
  final String? displayName;

  UserEntity({
    required this.uid,
    required this.email,
    required this.username,
    required this.password,
    this.avatar,
    this.displayName,
  });

  factory UserEntity.fromModel(UserModel userModel) {
    return UserEntity(
      uid: userModel.uid,
      email: userModel.email,
      username: userModel.username,
      password: userModel.password,
      avatar: userModel.avatar,
      displayName: userModel.displayName,
    );
  }

  String get nameDisplay => (displayName != null && displayName!.isNotEmpty) ? displayName! : username;
}
