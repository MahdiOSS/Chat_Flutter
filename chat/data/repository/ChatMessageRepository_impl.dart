import 'package:dartz/dartz.dart';
import 'package:syriamaksab/features/chat/data/models/Message_Entity.dart';


import '../data_sources/ChatMessageDataSource.dart';
import '../data_sources/Remote/ChatMessageDataSource_Remote.dart';
import '../../domain/repository/ChatMessageRepository.dart';


class ChatMessageRepositoryImpl implements ChatMessageRepository {
  final ChatMessageDataSource _chatMessageDataSource =
      ChatMessageDataSourceRemote();

  @override
  Future<Either<String, List<MessageEntity>>> getMessages(
      String userID, String adID) async {
    try {
      var response = await _chatMessageDataSource.getMessages(userID, adID);
      List<dynamic> json = response.data[0]['messages'];
      List<MessageEntity> messages =
          json.map((e) => MessageEntity.fromJson(e)).toList();
      return Right(messages);
    } catch (ex) {
      return Left(ex.toString());
    }
  }

  @override
  Future<Either<String, bool>> seenMessages(String adID) async {
    try {
      await _chatMessageDataSource.seenMessages(adID);
      return const Right(true);
    } catch (ex) {
      return Left(ex.toString());
    }
  }

  @override
  Future<Either<String, MessageEntity>> sendMessage(
      String userID, String adID, String message,String tempId) async {
    try {
      var response =
          await _chatMessageDataSource.sendMessage(userID, adID, message,tempId);
      Map<String, dynamic> json = response.data;
      MessageEntity messages = MessageEntity.fromJson2(json);
      return Right(messages);
    } catch (ex) {
      return Left(ex.toString());
    }
  }
}
