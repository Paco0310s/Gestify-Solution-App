import 'dart:convert';

class LoginBossDto {
  final String username;
  final String password;

  LoginBossDto({required this.username, required this.password});

  factory LoginBossDto.fromRawJson(String str) => LoginBossDto.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoginBossDto.fromJson(Map<String, dynamic> json) => LoginBossDto(username: json["username"], password: json["password"]);

  Map<String, dynamic> toJson() => {"username": username, "password": password};
}
