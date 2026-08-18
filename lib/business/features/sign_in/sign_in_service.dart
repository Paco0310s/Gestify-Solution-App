import 'package:gestify_solution/business/models/logged_boss_model.dart';
import 'package:gestify_solution/business/models/login_boss_dto.dart';
import 'package:gestify_solution/common/constants/app_config.dart';
import 'package:gestify_solution/common/errors/http_failure.dart';
import 'package:gestify_solution/common/services/dio_service.dart';
import 'package:gestify_solution/common/services/storage_service.dart';
import 'package:gestify_solution/common/utils/either.dart';

class SignInService {
  static Future<bool> isSignedIn() async {
    final String? accessToken = StorageService.getString(AppConfig.accessTokenKey);
    final String? refreshToken = StorageService.getString(AppConfig.refreshTokenKey);
    return accessToken != null && refreshToken != null;
  }

  static Future<EitherUtil<HttpFailure, bool>> validToken() async {
    return await DioService.post(AppConfig.validateTokenEndpoint, {
      "token": StorageService.getString(AppConfig.accessTokenKey),
    }, (json) => json['isValid'] as bool);
  }

  static Future<EitherUtil<HttpFailure, LoggedBossModel>> refreshToken() async {
    return await DioService.post(AppConfig.refreshTokenEndpoint, {
      "refreshToken": StorageService.getString(AppConfig.refreshTokenKey),
    }, (json) => LoggedBossModel.fromJson(json));
  }

  static Future<EitherUtil<HttpFailure, void>> logout() async {
    return await DioService.post(AppConfig.logoutEndpoint, {"refreshToken": StorageService.getString(AppConfig.refreshTokenKey)}, (_) {});
  }

  // static Future<EitherUtil<HttpFailure, CreatedBossModel>> getUserData() async {
  //   return await DioService.get<CreatedBossModel>(AppConfig.profileEndpoint, (json) => CreatedBossModel.fromJson(json));
  // }

  static Future<EitherUtil<HttpFailure, LoggedBossModel>> signIn(LoginBossDto loginDto) async {
    return await DioService.post(AppConfig.loginEndpoint, loginDto.toJson(), (json) => LoggedBossModel.fromJson(json));
  }
}
