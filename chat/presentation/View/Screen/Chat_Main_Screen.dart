import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syriamaksab/core/utils/logger.dart';
import 'package:syriamaksab/features/chat/data/models/Ads_Contact_Entity.dart';
import 'package:syriamaksab/features/chat/Pusher_Servies.dart';
import 'package:syriamaksab/features/chat/presentation/Bloc/Chat_Bloc.dart';
import 'package:syriamaksab/features/chat/presentation/Bloc/Chat_Event.dart';
import 'package:syriamaksab/features/chat/presentation/Bloc/Chat_State.dart';
import 'package:syriamaksab/features/chat/Timer_Provider.dart';
import '../Widget/Chat_AppBar_Widget.dart';
import '../Widget/Contact_Ads_Item_Widget.dart';

class ChatMainScreen extends StatefulWidget {
  ChatMainScreen({super.key,required this.userID});

  String userID;

  @override
  State<ChatMainScreen> createState() => _ChatMainScreenState();
}

class _ChatMainScreenState extends State<ChatMainScreen> {
  TimerProvider? stream;
  String? myUserName;


  @override
  void initState() {
    _getContactStream();
    _startStream(10);
    super.initState();
  }


  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _getAppbar(),
        backgroundColor: const Color(0xfff5f5f5),
        body: SafeArea(
            child: BlocConsumer<ChatBloc, ChatsState>(
                listener: (BuildContext context, ChatsState state) async {

                  if (state is ChatLoginSuccessState) {
                    state.user.fold((l) {
                      logError(l);
                    }, (r) {
                      logInfo(r.id ?? '');
                      myUserName = r.id;
                    });
                  }
                }, builder: (context, state) {
                  if(state is ChatInitState){
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                        child: LoadingAnimationWidget.waveDots(color: Colors.red, size: 60),
                      ),
                    );
                  }
              if (state is ChatAdsContactState) {
                return state.ads.fold(
                        (l) {
                          logError(l);
                          return const Center(child: Text('لطفا اتصال خود را برسی کنید...'));
                        }, (r) => _getContactAdsList(r));
              }
              return const Center(child: Text(''));
            })),
      );

  PreferredSizeWidget _getAppbar() {
    return const MyChatAppBar();
  }

  _getContactAdsList(List<AdsContactEntity> list) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemBuilder: (context, index) => ContactAdsItem(
        contact: list[0],
        // userName: myUserName ?? '',
        userName: widget.userID,
        timer: stream!,
      ),
      itemCount: list.length,
    );
  }

  _startStream(int delay) {
    stream = TimerProvider(
      timer: Timer.periodic(
        Duration(seconds: delay),
        (timer) => _getContactStream(),
      ),
    );
  }

  _getContactStream() {
    context.read<ChatBloc>().add(ChatGetAdsContactsEvent());
  }

  _getLogin() {
    context.read<ChatBloc>().add(ChatLoginEvent('test@gmail.com', '12345678'));
  }

  @override
  void dispose() {
    stream?.timer.cancel();
    MyPusherClient.getInstance()?.unSubscribe(widget.userID);
    super.dispose();
  }
}
