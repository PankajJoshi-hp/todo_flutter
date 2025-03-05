class Users {
  final int? id;
  final String? email;
  final String? name;
  final String? role;
  final String? avatar;

  Users({
    this.id,
    this.email,
    this.name,
    this.role,
    this.avatar,
  });

  factory Users.fromJson(Map<String, dynamic> json) => Users(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: json['role'],
      avatar: json['avatar']);
}
