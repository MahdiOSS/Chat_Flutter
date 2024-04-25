import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:syriamaksab/features/chat/data/models/Ad_Entity.dart';
import 'package:syriamaksab/features/chat/data/models/Message_Entity.dart';
import 'package:syriamaksab/features/chat/data/models/User_Entity.dart';

@immutable
class AdsContactEntity extends Equatable{
  UserEntity? userEntity;
  MessageEntity? messageEntity;
  AdEntity? adEntity;
  int? unseenCounter;

  AdsContactEntity(this.userEntity, this.messageEntity,this.adEntity, this.unseenCounter);

  factory AdsContactEntity.fromJson(Map<String, dynamic> json) =>
      AdsContactEntity(
          UserEntity.fromJson2(json['user']),
          MessageEntity.fromJson(json['lastMessage']),
          AdEntity.fromJson(json['ad_data']),
          json['unseenCounter'],
      );

  @override
  List<Object?> get props => [
    userEntity,
    messageEntity,
    adEntity
  ];
}
