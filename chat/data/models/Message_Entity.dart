class MessageEntity {
  String? id;
  String? senderId;
  String? receiverId;
  String? message;
  bool? seen;
  String? created_at;
  String? timeAgo;
  String? ad_owner;
  String? ad_id;
  String? tempId;
  int? status;

  MessageEntity(this.id, this.senderId, this.receiverId, this.message,
      this.seen, this.created_at, this.timeAgo, this.ad_id, this.ad_owner,this.tempId,this.status);

  factory MessageEntity.fromJson(Map<String, dynamic> json) => MessageEntity(
        json['id'],
        json['from_id'].toString(),
        json['to_id'].toString(),
        json['body'],
        json['seen'] == 1,
        json['created_at'],
        json['timeAgo'],
        json['ad_id'],
        json['ad_owner'],
        null,
       null
      );
//for send message
  factory MessageEntity.fromJson2(Map<String, dynamic> json) => MessageEntity(
    json['message']['id'],
    json['message']['from_id'].toString(),
    json['message']['to_id'].toString(),
    json['message']['message'],
    json['message']['seen'] == 1,
    json['message']['created_at'],
    json['message']['timeAgo'],
    json['message']['ad_id'],
    json['message']['ad_owner'],
    json['tempID'],
    json['status']
  );
// for receive message
  factory MessageEntity.fromJson3(Map<String, dynamic> json) => MessageEntity(
    json['message']['id'],
    json['message']['from_id'].toString(),
    json['message']['to_id'].toString(),
    json['message']['message'],
    json['seen'] == null ? false : true,
    json['created_at'],
    json['timeAgo'],
    json['message']['ad_id'],
    json['message']['ad_owner'],
    null,
    null
  );
}
