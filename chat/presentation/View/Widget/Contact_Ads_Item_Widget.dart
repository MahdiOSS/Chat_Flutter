import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syriamaksab/features/chat/data/models/Ads_Contact_Entity.dart';
import 'package:syriamaksab/features/chat/presentation/Bloc/Chat_Bloc.dart';
import 'package:syriamaksab/features/chat/presentation/Bloc/Chat_Event.dart';
import 'package:syriamaksab/features/chat/Timer_Provider.dart';
import '../Screen/Chat_User_Screen.dart';

@immutable
class ContactAdsItem extends StatelessWidget {
  const ContactAdsItem(
      {super.key, required this.contact, this.userName, required this.timer});

  final AdsContactEntity contact;
  final String? userName;
  final TimerProvider timer;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _initDesign();
        _goToChatUserScreen(context);
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: CachedNetworkImage(
                      // imageUrl: contact.adEntity?.ad_avatar ?? '',
                      imageUrl: contact.adEntity?.ad_avatar ?? '',
                      height: 70,
                      width: 70,
                      placeholder: (context, s) => ColoredBox(
                        color: Colors.grey.shade200,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0,right: 12.0,top: 13),
                          child: LoadingAnimationWidget.waveDots(
                              color: Colors.grey, size: 50),
                        ),
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  contact.adEntity?.ad_name ?? '...',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person_outline_rounded,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      contact.userEntity?.name ?? 'user',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                if (contact.unseenCounter! > 0)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 6),
                                    decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Text(
                                      '${contact.unseenCounter!} پیام جدید',
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    ),
                                  ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Visibility(
                                  visible:
                                      userName == contact.adEntity!.user_id,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.grey.shade200),
                                    child: const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'آگهی من',
                                        style: TextStyle(color: Colors.black45),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                contact.messageEntity?.message ?? '',
                                textDirection: TextDirection.rtl,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: contact.unseenCounter! > 0
                                        ? Colors.black87
                                        : Colors.grey),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Text(
                                contact.messageEntity?.timeAgo ?? '',
                                style: const TextStyle(
                                    color: Colors.blueGrey, fontSize: 12),
                                textDirection: TextDirection.ltr,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  _initDesign() {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Color(0xfff3f3f3),
        systemNavigationBarColor: Color(0xfff3f3f3),
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark));
  }

  _goToChatUserScreen(BuildContext context) {
    Navigator.of(context,rootNavigator: false).push(MaterialPageRoute(
        builder: (context) => BlocProvider<ChatBloc>(
              create: (BuildContext context) {
                var bloc = ChatBloc();
                bloc.add(ChatGetMessagesEvent(
                    contact.adEntity!.ad_id!, contact.userEntity!.id!));
                bloc.add(ChatSeenMessagesEvent(contact.adEntity!.ad_id!));
                return bloc;
              },
              child: ChatUserScreen(
                myUserID: userName,
                userName: contact.userEntity?.name,
                userID: contact.userEntity?.id,
                adID: contact.adEntity?.ad_id,
                img: '', title: '',
              ),
            )));
  }
}
