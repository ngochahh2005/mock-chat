import 'package:base_bloc_3/import.dart';

class DioBuilder {
  DioBuilder._();

  static Dio? _dio;
  static final DioBuilder _instance = DioBuilder._();

  factory DioBuilder() => _instance;

  Dio getDio() {
    if (_dio == null) {
      final BaseOptions options = BaseOptions(
        baseUrl: getUrl(),
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: ApiConfig.connectTimeout),
        receiveTimeout: const Duration(seconds: ApiConfig.receiveTimeout),
        headers: {"accept": "application/json"},
      );
      _dio = Dio(options);
      _dio?.options.headers['content-Type'] = 'application/json';
      _dio?.interceptors.addAll(
        [
          TalkerDioLogger(
            talker: getIt<Talker>(),
          ),
          DioInterceptor(_dio),
        ],
      );
    }
    return _dio!;
  }

  String getUrl() {
    return DefaultConfig.getBaseUrl;
  }
}
