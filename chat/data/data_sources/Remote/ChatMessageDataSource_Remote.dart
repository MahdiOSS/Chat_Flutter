import 'package:dio/dio.dart';
import 'package:dio/src/response.dart';
import 'package:syriamaksab/features/chat/Dio_Provider.dart';

import '../ChatMessageDataSource.dart';

class ChatMessageDataSourceRemote implements ChatMessageDataSource {
  
  var dio = DioProvider.getDioInstance();
  
  @override
  Future<Response> getMessages(String userID,String adID) {
    var body = {
      'user_id':userID,
      'ad_id':adID
    };
   return dio.post('fetch-messages',data: body,options: Options(maxRedirects: 2));
  }

  @override
  Future<Response> seenMessages(String adID) {
    var body = {
      'ad_id':adID
    };
    return dio.post('seen-message',data: body);
  }

  @override
  Future<Response> sendMessage(String userID, String adID, String message,String tempId) {
    var body = {
      'id':userID,
      'ad_id':adID,
      'message':message,
      'temporaryMsgId':tempId,
      'type':'user'
    };
    return dio.post('send-message',data: body);
  }
  
}