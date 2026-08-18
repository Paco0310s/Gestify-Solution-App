import 'dart:convert';
import 'package:gestify_solution/common/utils/validators.dart';

class CreateBossDto {
  final User user;
  final String phone;
  final String birthdate; // Formato: yyyy-MM-dd

  CreateBossDto({required this.user, required this.phone, required this.birthdate}) {
    if (ValidatorsUtil.validateBirthdate(birthdate) != null) {
      throw FormatException('Birthdate must be in the format yyyy-MM-dd and you must be at least 18 years old');
    }
  }

  factory CreateBossDto.fromRawJson(String str) => CreateBossDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CreateBossDto.fromJson(Map<String, dynamic> json) =>
      CreateBossDto(user: User.fromJson(json["user"]), phone: json["phone"], birthdate: json["birthdate"]);

  Map<String, dynamic> toJson() => {"user": user.toJson(), "phone": phone, "birthdate": birthdate};
}

class User {
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  User({required this.username, required this.email, required this.firstName, required this.lastName, required this.password});

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) =>
      User(username: json["username"], email: json["email"], firstName: json["firstName"], lastName: json["lastName"], password: json["password"]);

  Map<String, dynamic> toJson() => {"username": username, "email": email, "firstName": firstName, "lastName": lastName, "password": password};
}
