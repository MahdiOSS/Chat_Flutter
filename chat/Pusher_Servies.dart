import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';

import '../../core/utils/logger.dart';
import 'Dio_Provider.dart';

class MyPusherClient extends ChangeNotifier {
  MyPusherClient._internal();

  final PusherChannelsFlutter pusher = PusherChannelsFlutter.getInstance();

  Future<void> initPusher({required String userID}) async {
    if (userID.isEmpty) return;

    var data = await DioProvider.getDioInstance().get('get-pusher-config');

    await pusher.init(
      apiKey: data.data['pusher_key'],
      cluster: data.data['pusher_options']['cluster'],
      logToConsole: true,
      useTLS: true,
      onAuthorizer: (c, s, o) => onAuthorizer(
          c, s, o, data.data['pusher_secret'], data.data['pusher_app_id']),
      onSubscriptionSucceeded: onSubscriptionSucceeded,
      onSubscriptionError: onSubscriptionError,
    );
    await onSubscribe(userID);
    await pusher.connect();
  }

  dynamic onAuthorizer(String channelName, String socketId, dynamic options,
      String secret, String appId) async {
    var body = {'socket_id': socketId, 'channel_name': channelName};
    var data = await DioProvider.getDioInstance().post('chat-auth', data: body);

    var json = jsonDecode(data.data[0]);
    var auth = json['auth'];

    return {
      "auth": auth,
      "channel_data": json['channel_data'],
      "shared_secret": secret,
      "pusher_app_id": appId
    };
  }

  void onSubscriptionSucceeded(String channelName, dynamic data) {
    logInfo("onSubscriptionSucceeded: $channelName data: $data");
  }

  void onSubscriptionError(String message, dynamic e) {
    logInfo("onSubscriptionError: $message Exception: $e");
  }

  Future<void> onSubscribe(String userId) async {
    await pusher.subscribe(
      channelName: 'private-chatify.$userId',
    );
  }

  Future<void> unSubscribe(String userId) async {
    await pusher.unsubscribe(channelName: 'private-chatify.$userId');
  }

  void onMessage(dynamic data) {
    print('Message Recived');
  }

  static MyPusherClient? getInstance() {
    _instance ??= MyPusherClient._internal();
    return _instance;
  }
}

MyPusherClient? _instance;

