import 'package:gestify_solution/business/features/businesses/models/business_model.dart';
import 'package:gestify_solution/business/features/businesses/models/create_business_dto.dart';
import 'package:gestify_solution/common/constants/app_config.dart';
import 'package:gestify_solution/common/errors/http_failure.dart';
import 'package:gestify_solution/common/services/dio_service.dart';
import 'package:gestify_solution/common/services/storage_service.dart';
import 'package:gestify_solution/common/utils/either.dart';

class BusinessesService {
  /// Create a new business with multipart form-data (including logo and cover images)
  static Future<EitherUtil<HttpFailure, BusinessModel>> createBusiness(CreateBusinessDto dto) async {
    final formData = await dto.toFormData();
    return await DioService.postFormData<BusinessModel>(
      AppConfig.businessesEndpoint,
      formData,
      (json) => BusinessModel.fromJson(json),
      formDataBuilder: () => dto.toFormData(),
    );
  }

  /// Get list of businesses for the current logged-in boss/user
  static Future<EitherUtil<HttpFailure, List<BusinessModel>>> getBusinesses() async {
    final username = StorageService.getUsername();
    final url = (username != null && username.isNotEmpty)
        ? '${AppConfig.registerEndpoint}/$username/businesses'
        : AppConfig.businessesEndpoint;

    return await DioService.getArray<List<BusinessModel>>(
      url,
      (list) => list.map((item) => BusinessModel.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  /// Get single business by ID
  static Future<EitherUtil<HttpFailure, BusinessModel>> getBusinessById(String id) async {
    return await DioService.get<BusinessModel>(
      '${AppConfig.businessesEndpoint}/$id',
      (json) => BusinessModel.fromJson(json),
    );
  }

  /// Update an existing business by ID with multipart form-data
  static Future<EitherUtil<HttpFailure, BusinessModel>> updateBusiness(String id, CreateBusinessDto dto) async {
    final formData = await dto.toFormData();
    return await DioService.postFormData<BusinessModel>(
      '${AppConfig.businessesEndpoint}/$id',
      formData,
      (json) => BusinessModel.fromJson(json),
      formDataBuilder: () => dto.toFormData(),
    );
  }

  /// Delete business by ID
  static Future<EitherUtil<HttpFailure, bool>> deleteBusiness(String id) async {
    return await DioService.delete('${AppConfig.businessesEndpoint}/$id');
  }
}

