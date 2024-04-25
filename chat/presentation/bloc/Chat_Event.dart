import 'package:syriamaksab/features/chat/data/models/Message_Entity.dart';

class ChatEvent {}

class ChatLoginEvent extends ChatEvent {
  String email;
  String password;
  ChatLoginEvent(this.email,this.password);
}

class ChatGetAdsContactsEvent extends ChatEvent {}

class ChatGetMessagesEvent extends ChatEvent {
  String userID;
  String adID;
  ChatGetMessagesEvent(this.adID,this.userID);
}

class ChatSeenMessagesEvent extends ChatEvent {
  String adID;
  ChatSeenMessagesEvent(this.adID);
}

class ChatSendMessageEvent extends ChatEvent {
  String userID;
  String adID;
  String message;
  String tempId;
  int time;
  ChatSendMessageEvent(this.adID,this.userID,this.message,this.tempId,this.time);
}

class ChatPusherAuthEvent extends ChatEvent {
  String userID;
  String adID;
  ChatPusherAuthEvent(this.adID,this.userID);
}

class ChatPusherReceiveMessageEvent extends ChatEvent {
 MessageEntity messageEntity;
 ChatPusherReceiveMessageEvent(this.messageEntity);
}