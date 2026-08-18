import 'dart:convert';

class LoggedBossModel {
  final String accessToken;
  final String refreshToken;
  final String tokenType;
  final int expiresIn;
  final int refreshExpiresIn;
  final String sessionState;
  final String scope;

  LoggedBossModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenType,
    required this.expiresIn,
    required this.refreshExpiresIn,
    required this.sessionState,
    required this.scope,
  });

  factory LoggedBossModel.fromRawJson(String str) => LoggedBossModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory LoggedBossModel.fromJson(Map<String, dynamic> json) => LoggedBossModel(
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
    refreshExpiresIn: json["refresh_expires_in"],
    sessionState: json["session_state"],
    scope: json["scope"],
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "token_type": tokenType,
    "expires_in": expiresIn,
    "refresh_expires_in": refreshExpiresIn,
    "session_state": sessionState,
    "scope": scope,
  };
}
