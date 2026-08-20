import 'package:base_bloc_3/features/authen/presentation/bloc/auth_bloc.dart';
import 'package:base_bloc_3/import.dart';

class DioInterceptor extends Interceptor {
  final Dio? dio;

  DioInterceptor(this.dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handleError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    ///valid response
    if (response.statusCode == 200 &&
        response.data != null &&
        response.data is Map &&
        response.data["data"] != null) {
      //if response has any error
      if (response.data["data"] is Map &&
          response.data["data"]["errors"] != null) {
        return handler.reject(
          DioException(
            type: DioExceptionType.badResponse,
            requestOptions: response.requestOptions,
            response: response,
          ),
        );
      }
    }
    super.onResponse(response, handler);
  }

  Future<void> handleError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check network connection
    if (await _handleNetworkError(err, handler)) {
      return;
    }

    // Handle unauthorized error (401)
    if (StatusCode.unauthorized == err.response?.statusCode) {
      await _handleUnauthorizedError(err, handler);
      return;
    }

    // Forward other errors
    handler.next(err);
  }

  /// Handle network connectivity errors
  Future<bool> _handleNetworkError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.type != DioExceptionType.unknown) {
      return false;
    }

    final connectivityResult =
        await getIt<Connectivity>().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      final networkError = err.copyWith(
        message: S.current.no_internet_access,
      );
      super.onError(networkError, handler);
      return true;
    }

    return false;
  }

  /// Handle unauthorized (401) errors with token refresh
  Future<void> _handleUnauthorizedError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
      navigateToLogin();
      handler.reject(err);
  }

  void navigateToLogin() {
    //clear token
    //go to login
    getIt<AuthBloc>().add(const AuthEvent.onLogoutEvent());
  }
}
