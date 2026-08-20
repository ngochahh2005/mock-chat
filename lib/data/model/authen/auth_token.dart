import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_token.freezed.dart';
part 'auth_token.g.dart';

@freezed
abstract class AuthToken with _$AuthToken {
  const factory AuthToken({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    String? expiresIn,
  }) = _AuthToken;

  factory AuthToken.fromJson(Map<String, dynamic> json) =>
      _$AuthTokenFromJson(json);
}
