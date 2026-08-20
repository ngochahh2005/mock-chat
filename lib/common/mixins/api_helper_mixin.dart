import 'package:base_bloc_3/import.dart';

/// Mixin to handle common API call patterns with error handling
/// 
/// This mixin provides reusable methods for handling API calls with
/// automatic error handling and transformation to Either<BaseError, T>
mixin ApiHelperMixin {
  /// Get logger instance from dependency injection
  Talker get logger => getIt<Talker>();

  /// Handle API call with custom transform function
  /// 
  /// Use this when you need to transform the response data
  /// Example:
  /// ```dart
  /// return handleApiCallWithTransform(
  ///   () => service.getData(),
  ///   (data) => data.map((e) => Entity.fromModel(e)).toList(),
  /// );
  /// ```
  Future<Either<BaseError, List<R>>> handleApiCallWithTransform<T, R>(
    Future<T> Function() apiCall,
    List<R> Function(T data) transform,
  ) async {
    try {
      final result = await apiCall();
      return right(transform(result));
    } catch (e) {
      logger.error(e, null, StackTrace.current);
      return left(handleApiError(e));
    }
  }

  /// Handle API call that returns BaseData<T>
  /// 
  /// Use this for APIs that return BaseData wrapper with single object
  /// Example:
  /// ```dart
  /// return handleBaseDataApiCall(
  ///   () => service.getUser(),
  ///   (model) => UserEntity.fromModel(model),
  /// );
  /// ```
  Future<Either<BaseError, R>> handleBaseDataApiCall<T, R>(
    Future<BaseData<T>> Function() apiCall,
    R Function(T model) fromModel,
  ) async {
    try {
      final result = await apiCall();
      final data = result.data;
      if (data == null) {
        return left(
          BaseError.httpInternalServerError(S.current.error_system),
        );
      }
      return right(fromModel(data));
    } catch (e) {
      logger.error(e, null, StackTrace.current);
      return left(handleApiError(e));
    }
  }

  /// Handle API call that returns BaseListData<T>
  /// 
  /// Use this for APIs that return BaseListData wrapper with list
  /// Example:
  /// ```dart
  /// return handleBaseListDataApiCall(
  ///   () => service.getProducts(request: request),
  ///   (model) => ProductEntity.fromModel(model),
  /// );
  /// ```
  Future<Either<BaseError, List<R>>> handleBaseListDataApiCall<T, R>(
    Future<BaseListData<T>> Function() apiCall,
    R Function(T model) fromModel,
  ) async {
    try {
      final result = await apiCall();
      return right(
        (result.data ?? []).map((e) => fromModel(e)).toList(),
      );
    } catch (e) {
      logger.error(e, null, StackTrace.current);
      return left(handleApiError(e));
    }
  }

  /// Handle API call with direct conversion
  /// 
  /// Use this when API returns data directly without BaseData wrapper
  /// Example:
  /// ```dart
  /// return handleApiCallWithConvert(
  ///   () => service.getConfig(),
  ///   (model) => ConfigEntity.fromModel(model),
  /// );
  /// ```
  Future<Either<BaseError, R>> handleApiCallWithConvert<T, R>(
    Future<T> Function() apiCall,
    R Function(T model) fromModel,
  ) async {
    try {
      final result = await apiCall();
      return right(fromModel(result));
    } catch (e) {
      logger.error(e, null, StackTrace.current);
      return left(handleApiError(e));
    }
  }

  /// Handle API call without BaseData wrapper
  /// 
  /// Alias for handleApiCallWithConvert for clarity
  Future<Either<BaseError, R>> handleWithoutBaseDataApiCall<T, R>(
    Future<T> Function() apiCall,
    R Function(T model) fromModel,
  ) async {
    return handleApiCallWithConvert(apiCall, fromModel);
  }

  /// Handle API call that returns void
  /// 
  /// Use this for APIs that don't return any data
  /// Example:
  /// ```dart
  /// return handleVoidApiCall(
  ///   () => service.deleteItem(id: id),
  /// );
  /// ```
  Future<Either<BaseError, void>> handleVoidApiCall(
    Future<void> Function() apiCall,
  ) async {
    try {
      await apiCall();
      return right(null);
    } catch (e) {
      logger.error(e, null, StackTrace.current);
      return left(handleApiError(e));
    }
  }

  /// Handle API call that returns data directly (no conversion needed)
  /// 
  /// Use this when the API returns the exact type you need
  /// Example:
  /// ```dart
  /// return handleDirectApiCall(
  ///   () => service.login(request: request),
  /// );
  /// ```
  Future<Either<BaseError, T>> handleDirectApiCall<T>(
    Future<T> Function() apiCall,
  ) async {
    try {
      final result = await apiCall();
      return right(result);
    } catch (e) {
      logger.error(e, null, StackTrace.current);
      return left(handleApiError(e));
    }
  }

  /// Common error handler for API calls
  /// 
  /// Converts various error types to BaseError
  BaseError handleApiError(dynamic error) {
    if (error is DioException) {
      return error.baseError;
    } else {
      // Handle other types of errors
      logger.error('Unknown error type: ${error.runtimeType}', error, StackTrace.current);
      return BaseError.httpUnknownError(S.current.error_system);
    }
  }
}

