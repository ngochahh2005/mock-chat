import 'package:json_annotation/json_annotation.dart';

part 'login_success_model.g.dart';

@JsonSerializable()
class LoginSuccessModel {
  final String accessToken;

  const LoginSuccessModel({
    required this.accessToken,
  });

  factory LoginSuccessModel.fromJson(Map<String, dynamic> json) =>
      _$LoginSuccessModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginSuccessModelToJson(this);
}
