import 'package:dio/dio.dart';

abstract class ChatMessageDataSource {
  Future<Response<dynamic>> getMessages(String userID,String adID);
  Future<Response<dynamic>> seenMessages(String adID);
  Future<Response<dynamic>> sendMessage(String userID,String adID,String message,String tempId);
}