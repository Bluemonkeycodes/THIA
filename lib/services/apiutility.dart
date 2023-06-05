import 'package:dio/dio.dart';

import '../utils/utils.dart';

class APIProvider {
  static Dio? dio = Dio(options);
  static BaseOptions? options = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 30000),
      validateStatus: (code) {
        if (code! >= 200) {
          return true;
        }
        return false;
      });
  static Dio getDio() {
    return dio!;
  }
}
