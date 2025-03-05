class SingleUserModel {
  final int? id;
  final String? email;
  final String? password;
  final String? name;
  final String? role;
  final String? avatar;
  final String? creationAt;
  final String? updatedAt;

  SingleUserModel({
    this.id,
    this.email,
    this.password,
    this.name,
    this.role,
    this.avatar,
    this.creationAt,
    this.updatedAt,
  });

  factory SingleUserModel.fromJson(Map<String, dynamic> json) =>
      SingleUserModel(
        id: json['id'],
        email: json['email'],
        password: json['password'],
        name: json['name'],
        role: json['role'],
        avatar: json['avatar'],
        creationAt: json['creationAt'],
        updatedAt: json['updatedAt'],
      );
}
