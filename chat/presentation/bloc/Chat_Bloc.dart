import 'dart:async';
import 'dart:collection';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:syriamaksab/core/utils/logger.dart';
import 'package:syriamaksab/features/chat/data/repository/ChatMessageRepository_impl.dart';
import 'package:syriamaksab/features/chat/domain/repository/UserRepository.dart';
import 'package:syriamaksab/features/chat/data/repository/UserRepository_impl.dart';
import 'package:syriamaksab/features/chat/presentation/Bloc/Chat_State.dart';
import '../../data/models/Message_Entity.dart';
import '../../domain/repository/ChatMessageRepository.dart';
import 'Chat_Event.dart';
import 'package:synchronized/synchronized.dart';

class MyMessageContent {
  String? userID;
  String? adID;
  String? message;
  String? tempID;
  int time;

  MyMessageContent(this.userID, this.adID, this.message, this.tempID,this.time);
}

class ChatBloc extends Bloc<ChatEvent, ChatsState> {
  UserRepository userRepository = UserRepositoryImpl();
  final ChatMessageRepository _messageRepository = ChatMessageRepositoryImpl();

  final lock = Lock();

  ChatBloc() : super(ChatInitState()) {
    on<ChatLoginEvent>((event, emit) async {
      var user = await userRepository.loginUser(event.email, event.password);
      emit(ChatLoginSuccessState(user));
    });

    on<ChatGetAdsContactsEvent>((event, emit) async {
      var ads = await userRepository.getAdsContact();
      logInfo('stream 1');
      emit(ChatAdsContactState(ads));
    });

    on<ChatGetMessagesEvent>((event, emit) async {
      emit(ChatLoadingState(true));

      var message =
      await _messageRepository.getMessages(event.userID, event.adID);
      emit(ChatLoadingState(false));
      emit(ChatMessagesState(message));
    });

    on<ChatSeenMessagesEvent>((event, emit) {
      _messageRepository.seenMessages(event.adID);
    });

    on<ChatSendMessageEvent>((event, emit) async {

     await lock.synchronized(() async {
        var message = await _messageRepository.sendMessage(
            event.userID, event.adID, event.message, event.tempId);
        await Future.delayed(const Duration(milliseconds: 0));
        emit(ChatSendSuccessMessageState(message));
      });

    });

    on<ChatPusherReceiveMessageEvent>((event, emit) async {
      emit(ChatReceiveSuccessMessageState(event.messageEntity));
    });
  }
}
