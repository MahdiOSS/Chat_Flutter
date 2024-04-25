import 'package:dio/dio.dart';

const CHAT_TOKEN = 'Your Token'
class DioProvider {
  static final DioProvider _instance = DioProvider._internal();

  factory DioProvider() {
    return _instance;
  }

  DioProvider._internal() {
    dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 60),
        receiveDataWhenStatusError: true,
        maxRedirects: 2,
        baseUrl: "your server uri",
        headers: {
          'Authorization': 'Bearer $CHAT_TOKEN',
          'Connection': 'keep-alive'
        }));
  }

  late final Dio dio;

  static Dio getDioInstance() {
    return _instance.dio;
  }
}
