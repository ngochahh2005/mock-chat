import 'package:base_bloc_3/import.dart';

part 'error_response.freezed.dart';
part 'error_response.g.dart';

@freezed
abstract class Error with _$Error {
  const factory Error({
    @JsonKey(name: "error_code") final StatusCodeEnum? errorCode,
    @JsonKey(name: "error_message") final String? errorMessage,
  }) = _Error;

  factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);
}

@freezed
abstract class Data with _$Data {
  const factory Data({
    final List<Error>? errors,
  }) = _Data;

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}

@freezed
abstract class ErrorResponse with _$ErrorResponse {
  const factory ErrorResponse({
    final Data? data,
  }) = _ErrorResponse;

  factory ErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ErrorResponseFromJson(json);
}
