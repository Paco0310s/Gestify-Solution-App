import 'dart:convert';

class CreatedBossModel {
  final int id;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final String createdBy;
  final String? updatedBy;
  final String? deletedBy;
  final User user;
  final String phone;
  final DateTime birthdate;

  CreatedBossModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.createdBy,
    required this.updatedBy,
    required this.deletedBy,
    required this.user,
    required this.phone,
    required this.birthdate,
  });

  factory CreatedBossModel.fromRawJson(String str) => CreatedBossModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreatedBossModel.fromJson(Map<String, dynamic> json) => CreatedBossModel(
    id: json["id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"] == null ? null : DateTime.parse(json["deletedAt"]),
    createdBy: json["createdBy"],
    updatedBy: json["updatedBy"],
    deletedBy: json["deletedBy"],
    user: User.fromJson(json["user"]),
    phone: json["phone"],
    birthdate: DateTime.parse(json["birthdate"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt,
    "deletedAt": deletedAt,
    "createdBy": createdBy,
    "updatedBy": updatedBy,
    "deletedBy": deletedBy,
    "user": user.toJson(),
    "phone": phone,
    "birthdate": "${birthdate.year.toString().padLeft(4, '0')}-${birthdate.month.toString().padLeft(2, '0')}-${birthdate.day.toString().padLeft(2, '0')}",
  };
}

class User {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final bool active;

  User({required this.username, required this.email, required this.firstName, required this.lastName, required this.active});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) =>
      User(username: json["username"], email: json["email"], firstName: json["firstName"], lastName: json["lastName"], active: json["active"]);

  Map<String, dynamic> toJson() => {"username": username, "email": email, "firstName": firstName, "lastName": lastName, "active": active};
}
