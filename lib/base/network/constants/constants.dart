import 'package:base_bloc_3/import.dart';

class StatusCode {
  static const int verifyOtpError = 117;
  static const int error = 400;
  static const int unauthorized = 401;
  static const int notFound = 404;
  static const int permissionDenied = 403;
  static const int success = 200;
}

enum StatusCodeEnum {
  @JsonValue(StatusCode.verifyOtpError)
  verifyOtpError,
  @JsonValue(StatusCode.error)
  error,
  @JsonValue(StatusCode.unauthorized)
  unauthorized,
  @JsonValue(StatusCode.notFound)
  notFound,
  @JsonValue(StatusCode.permissionDenied)
  permissionDenied;
}

extension StatusCodeEnumExtension on StatusCodeEnum {
  BaseError get message {
    switch (this) {
      case StatusCodeEnum.verifyOtpError:
        return BaseError.httpInternalServerError(S.current.invalid_otp);
      case StatusCodeEnum.error:
        return BaseError.httpInternalServerError(S.current.error_system);
      case StatusCodeEnum.unauthorized:
        return const BaseError.httpUnAuthorizedError();
      case StatusCodeEnum.notFound:
        return BaseError.httpInternalServerError(S.current.not_found);
      case StatusCodeEnum.permissionDenied:
        return BaseError.httpInternalServerError(S.current.permission_denied);
    }
  }
}

class KeyRequest {
  static const String authorization = "Authorization";
  static const String bearer = "Bearer";
  static const String retry = "retry";
}
