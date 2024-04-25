import 'package:dartz/dartz.dart';
import 'package:syriamaksab/features/chat/data/models/Message_Entity.dart';

abstract class ChatMessageRepository {
  Future<Either<String,List<MessageEntity>>> getMessages(String userID,String adID);
  Future<Either<String,bool>> seenMessages(String adID);
  Future<Either<String,MessageEntity>> sendMessage(String userID,String adID,String message,String tempId);
}