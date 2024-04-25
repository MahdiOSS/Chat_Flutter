import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:syriamaksab/core/utils/logger.dart';
import 'package:syriamaksab/features/chat/data/models/Message_Entity.dart';
import 'package:syriamaksab/features/chat/Pusher_Servies.dart';
import 'package:syriamaksab/features/chat/presentation/Bloc/Chat_Bloc.dart';
import 'package:syriamaksab/features/chat/presentation/Bloc/Chat_Event.dart';
import 'package:syriamaksab/features/chat/presentation/Bloc/Chat_State.dart';
import 'package:syriamaksab/features/chat/presentation/View/Widget/Chat_Message_Size_Widget.dart';

enum MessageState { PROGRESS, FAILER, SENT, SENT2 }

class ChatUserScreen extends StatefulWidget {
  ChatUserScreen(
      {super.key,
      required this.myUserID,
      required this.userName,
      required this.userID,
      required this.adID,
      required this.img,
      required this.title});

  //for your id --> user 1
  String? myUserID;
  String? userName;

  //for your friend --> user 2
  String? userID;
  String? adID;
  String? img;
  String? title;

  @override
  State<ChatUserScreen> createState() => _ChatUserScreenState();
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  var enable = true;

  @override
  void initState() {
    super.initState();
    MyPusherClient.getInstance()?.pusher.onEvent = (data) {
      try {
        var json = jsonDecode(data.data);
        print('Message --> ${json['message']['id'].toString()}');
        MessageEntity message = MessageEntity.fromJson3(json);
        context.read<ChatBloc>().add(ChatPusherReceiveMessageEvent(message));
        context.read<ChatBloc>().add(ChatSeenMessagesEvent(widget.adID!));
      } catch (e) {
        logError(e.toString());
      }
    };
  }

  final List<types.Message> _messages = [];
  var messageState = MessageState.PROGRESS;

  // final types.User _user = const types.User(id: '1');
  TextEditingController controller = TextEditingController();
  bool hasMessage = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ChatBloc, ChatsState>(
      listener: (BuildContext context, Object? state) async {
        if (state is ChatReceiveSuccessMessageState) {
          print('message in state !');
          var message = state.message;

          _addMessageToDisplay(CustomMessage(
              author: types.User(id: message.senderId!),
              id: message.id!,
              metadata: {'data': message.message, 'state': MessageState.SENT},
              showStatus: message.seen));

          for (var element in _messages) {
            if (element.showStatus! == false) {
              setState(() {
                _messages[_messages.indexOf(element)] =
                    element.copyWith(showStatus: true);
              });
            }
          }
        }

        if (state is ChatSendSuccessMessageState) {
          state.message.fold((l) {
            var m = _messages[0];
            var mm = m.copyWith(metadata: {
              'data': m.metadata?['data'],
              'state': MessageState.FAILER
            });
            setState(() {
              _messages.removeAt(0);
              _addMessageToDisplay(mm);
            });
          }, (r) async {
            var message = types.CustomMessage(
                author: types.User(id: r.senderId!),
                id: r.tempId!,
                createdAt:
                    DateTime.parse(r.created_at!).timeZoneOffset.inSeconds,
                metadata: {
                  'data': r.message,
                  'state': MessageState.SENT,
                },
                showStatus: r.seen);

            logInfo('ID --> '+message.id);

              for (var value in _messages) {
                if(value.id == message.id){
                  setState(() {
                    logInfo('msg == ${_messages[_messages.indexOf(value)].metadata?['data']}');
                    _messages[_messages.indexOf(value)] = message;
                  });
                }
              }

          });
        }

        if (state is ChatMessagesState) {
          state.messages.fold((l) {
            logError(l);
          }, (r) {
            var list = r.reversed.toList();
            setState(() {
              _loadMessages(list);
            });
          });
        }
      },
      builder: (BuildContext context, state) {
        return Scaffold(body: _getUi(state));
      },
    );
  }

  Widget _getUi(ChatsState state) {
    return Column(
      children: [_getAppBar(), _getChatView(state)],
    );
  }

  _getChatView(ChatsState state) {
    return Expanded(
      child: Chat(
        userAgent: widget.myUserID,
        emptyState: state is ChatLoadingState
            ? const Center(
                child: CircularProgressIndicator(
                color: Colors.redAccent,
                strokeWidth: 3,
              ))
            : _getEmptyState(),
        theme: _getChatTheme(),
        messages: _messages,
        onSendPressed: _userOnSendPressed,
        user: types.User(id: widget.myUserID!),
        customBottomWidget: _getCustomBottomSendMessageWidget(),
        customMessageBuilder: createCustomMessageWidget,
      ),
    );
  }

  _getCustomBottomSendMessageWidget() {
    return AnimatedContainer(
        width: double.infinity,
        height: 65,
        color: const Color(0xfff6f6f6),
        duration: const Duration(milliseconds: 500),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 40,
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              Row(
                children: [
                  SizedBox(
                      width: 250,
                      height: 46,
                      child: TextField(
                        textAlign: TextAlign.end,
                        onChanged: (q) {
                          if (q.isNotEmpty) {
                            setState(() {
                              hasMessage = true;
                            });
                          } else {
                            setState(() {
                              hasMessage = false;
                            });
                          }
                        },
                        cursorColor: Colors.red,
                        controller: controller,
                        decoration: const InputDecoration(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            hintText: 'پیامی بنویسید',
                            hintStyle: TextStyle(color: Colors.black45),
                            border: OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red))),
                      )),
                  const SizedBox(
                    width: 8,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: SizedBox(
                      width: 50,
                      height: 45,
                      child: ElevatedButton(

                        onPressed: () {
                          if (controller.text.isNotEmpty) {

                            _userOnSendPressed(
                                types.PartialText(text: controller.text));
                            controller.text = '';
                            setState(() {
                              enable = false;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white70),
                        child: Icon(
                          Icons.send_rounded,
                          size: 24,
                          color: hasMessage ? Colors.red : Colors.black87,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  )
                ],
              ),
            ],
          ),
        ));
  }

  _getChatTheme() {
    return const DefaultChatTheme(
      backgroundColor: Color(0xfffdfdfd),
      primaryColor: Color(0xffe2ebf0),
      messageBorderRadius: 12,
      messageInsetsHorizontal: 8,
      secondaryColor: Color(0xffefefef),
      sentMessageBodyTextStyle:
          TextStyle(color: Colors.black87, letterSpacing: 0.8),
    );
  }

  _getEmptyState() {
    return const Center(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Text('هیچ پیامی برای نمایش شما ندارید !'),
      ),
    );
  }

  _getAppBar() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          AppBar(
            backgroundColor: const Color(0xfff3f3f3),
            title: Text(
              widget.userName ?? 'کاربر',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.black87,letterSpacing: -0.3),
            ),
          ),
          Container(
            height: 48,
            color: const Color(0xffe5e5e5e5).withOpacity(0.8),
            // decoration: BoxDecoration(
            //   color: Colors.grey
            // ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius:BorderRadius.circular(6),
                    child: CachedNetworkImage(imageUrl: 'https://themvp.in/catalog/view/assets/img/PC-Shravan-Kumar.webp' ?? '',width: 38,height: 38,),
                  ),
                  const SizedBox(width: 16,),
                  const Text('کیس قوی گیم',style: TextStyle(color: Colors.black54),)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  _userOnSendPressed(types.PartialText text) {
    setState(() {
      hasMessage = false;
    });
    var message = types.CustomMessage(
        author: types.User(id: widget.myUserID!),
        createdAt: DateTime.now().minute,
        id: Random.secure().nextDouble().toString(),
        metadata: {'data': text.text, 'state': messageState},
        showStatus: false);
    logInfo('SENDED ${message.id}');

    _addMessageToDisplay(message);

    _sendMessageEvent(text.text,message.id);
  }

  _addMessageToDisplay(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  _loadMessages(List<MessageEntity> list) {
    for (int i = 0; i < list.length; i++) {
      var message = list[i];
      if (!_messages.contains(message)) {
        _addMessageToDisplay(types.CustomMessage(
            author: types.User(id: message.senderId!),
            id: message.id!,
            createdAt: DateTime.parse(message.created_at!).hour,
            showStatus: message.seen,
            metadata: {'data': message.message, 'state': MessageState.SENT}));
      }
    }
  }

  _sendMessageEvent(String message,String tempId) {
    context
        .read<ChatBloc>()
        .add(ChatSendMessageEvent(widget.adID!, widget.userID!, message,tempId,DateTime.now().microsecond));
  }

  Widget createCustomMessageWidget(CustomMessage message,
      {required int messageWidth}) {
    return SizedBox(
        width: getTextSize(message.metadata!['data'].toString()).toDouble(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Center(
                child: Text(
                  message.metadata?['data'],
                  textAlign: TextAlign.end,
                ),
              ),
              if (widget.myUserID == message.author.id) ...{
                if (message.metadata?['state'] == MessageState.PROGRESS) ...{
                  Container(
                      margin: const EdgeInsets.only(right: 4),
                      width: 10,
                      height: 10,
                      child: const CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: Colors.red,
                      ))
                },
                if (message.metadata?['state'] == MessageState.SENT) ...{
                  Icon(
                    message.showStatus!
                        ? Icons.done_all_rounded
                        : Icons.done_rounded,
                    color: Colors.green,
                    size: 16,
                  ),
                },
                if (message.metadata?['state'] == MessageState.FAILER) ...{
                  const Icon(
                    Icons.sms_failed_rounded,
                    color: Colors.redAccent,
                    size: 12,
                  ),
                }
              }
            ],
          ),
        )); // با منطق UI سفارشی خود جایگزین کنید
  }
}
