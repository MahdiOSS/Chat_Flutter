import 'package:dio/dio.dart';

abstract class UserDataSource {
  Future<Response<dynamic>> login (String email,String password);
  Future<Response<dynamic>> getAdsContact ();
}