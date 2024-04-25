import 'package:dartz/dartz.dart';
import 'package:syriamaksab/features/chat/data/models/Ads_Contact_Entity.dart';
import 'package:syriamaksab/features/chat/data/models/Message_Entity.dart';
import 'package:syriamaksab/features/chat/data/models/User_Entity.dart';

class ChatsState{

}

class ChatInitState extends ChatsState {}

class ChatLoadingState extends ChatsState {
  bool active;
  ChatLoadingState(this.active);
}

class ChatLoadingSendMessageState extends ChatsState {
  bool sent;
  ChatLoadingSendMessageState(this.sent);
}

class ChatLoginSuccessState extends ChatsState {
  Either<String,UserEntity> user;
  ChatLoginSuccessState(this.user);
}

class ChatAdsContactState extends ChatsState {
  Either<String,List<AdsContactEntity>> ads;
  ChatAdsContactState(this.ads);
}

class ChatMessagesState extends ChatsState {
  Either<String,List<MessageEntity>> messages;
  ChatMessagesState(this.messages);
}

class ChatSendSuccessMessageState extends ChatsState {
  Either<String,MessageEntity> message;
  ChatSendSuccessMessageState(this.message);
}

class ChatReceiveSuccessMessageState extends ChatsState {
  MessageEntity message;
  ChatReceiveSuccessMessageState(this.message);
}