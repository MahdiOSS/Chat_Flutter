class AdEntity {
  String? ad_id;
  String? ad_name;
  String? ad_avatar;
  String? user_id;
  String? user_name;

  AdEntity(
      this.ad_id, this.ad_name, this.ad_avatar, this.user_id, this.user_name);

  factory AdEntity.fromJson(Map<String, dynamic> json) => AdEntity(
        json['ad_id'].toString(),
        json['ad_name'],
        json['ad_avatar'],
        json['user_id'].toString(),
        json['user_name'],
      );
}
