import 'package:base_bloc_3/import.dart';

extension DioErrorMessage on DioException {
  BaseError get baseError {
    BaseError errorMessage = BaseError.httpUnknownError(S.current.error_system);
    switch (type) {
      case DioExceptionType.cancel:
        errorMessage = BaseError.httpUnknownError(S.current.dio_cancel_request);
        break;
      case DioExceptionType.connectionTimeout:
        errorMessage = BaseError.httpUnknownError(S.current.dio_cancel_request);
        break;
      case DioExceptionType.unknown:
        if (error != null && error is SocketException) {
          errorMessage =
              BaseError.httpInternalServerError(S.current.no_internet_access);
        }
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = BaseError.httpUnknownError(S.current.dio_cancel_request);
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = BaseError.httpUnknownError(S.current.dio_cancel_request);
        break;
      case DioExceptionType.badResponse:
        try {
          ErrorResponse errorResponse = ErrorResponse.fromJson(response?.data);
          final errors = errorResponse.data?.errors;
          final code = (errors != null && errors.isNotEmpty)
              ? errors.first.errorCode
              : null;
          if (code == StatusCodeEnum.unauthorized) {
            errorMessage = const BaseError.httpUnAuthorizedError();
          } else {
            errorMessage = code?.message ??
                BaseError.httpInternalServerError(S.current.error_system);
          }
        } catch (e) {
          errorMessage = BaseError.httpInternalServerError(S.current.error_system);
        }
        break;
      default:
        errorMessage = BaseError.httpUnknownError(S.current.error_system);
        break;
    }
    return errorMessage;
  }
}

extension BaseErrorMessage on BaseError {
  String get getErrorString {
    if (this is HttpInternalServerError) {
      return (this as HttpInternalServerError).errorBody;
    } else if (this is HttpUnAuthorizedError) {
      return S.current.error_system;
    } else if (this is HttpUnknownError) {
      return (this as HttpUnknownError).message;
    }
    return S.current.error_system; //todo: specify error string
  }
}
