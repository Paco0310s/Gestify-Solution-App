import 'package:gestify_solution/business/models/create_boss_dto.dart';
import 'package:gestify_solution/business/models/created_boss_model.dart';
import 'package:gestify_solution/common/constants/app_config.dart';
import 'package:gestify_solution/common/errors/http_failure.dart';
import 'package:gestify_solution/common/services/dio_service.dart';
import 'package:gestify_solution/common/utils/either.dart';

class SignUpService {
  static Future<EitherUtil<HttpFailure, CreatedBossModel>> signUp(CreateBossDto createBossDto) async {
    return await DioService.post(AppConfig.registerEndpoint, createBossDto.toJson(), (json) => CreatedBossModel.fromJson(json));
  }
}
