class UserEntity {
  String? id;
  String? name;
  String? email;
  String? created_at;

  UserEntity(this.id, this.name, this.email, this.created_at);

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
      json['id'].toString(),
      json['name'],
      json['email'],
      json['created_at'],
      );

  factory UserEntity.fromJson2(Map<String, dynamic> json) => UserEntity(
        json['user_id'].toString(),
        json['name'],
        null,
        null,
      );
}
