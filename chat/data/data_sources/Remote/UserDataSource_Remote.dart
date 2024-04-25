import 'package:dio/dio.dart';
import 'package:syriamaksab/features/chat/Dio_Provider.dart';

import '../UserDataSource.dart';


class UserDataSourceRemote implements UserDataSource {
  //For test

  @override
  Future<Response<dynamic>> login(String email, String password) {
    var body = {
      'email':email,
      'password':password
    };
    return DioProvider.getDioInstance().post('login',data: body);
  }

  @override
  Future<Response> getAdsContact() {
   return DioProvider.getDioInstance().get('contacts');
  }


}