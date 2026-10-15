import 'package:gestify_solution/business/features/businesses/models/businesses_type_model.dart';
import 'package:gestify_solution/business/features/businesses/models/file_response_dto.dart';
import 'package:gestify_solution/business/features/businesses/models/industries_model.dart';
import 'package:gestify_solution/business/features/businesses/models/types_regimens_taxes_model.dart';

class BusinessModel {
  final String id;
  final String name;
  final String description;
  final String rfc;
  final String? establishmentDate;
  final bool active;
  final IndustriesModel? industry;
  final BusinessesTypeModel? businessesType;
  final TypesRegimensTaxesModel? taxRegimen;
  final FileResponseDto? logo;
  final FileResponseDto? cover;

  BusinessModel({
    required this.id,
    required this.name,
    required this.description,
    required this.rfc,
    this.establishmentDate,
    this.active = true,
    this.industry,
    this.businessesType,
    this.taxRegimen,
    this.logo,
    this.cover,
  });

  String? get logoUrl => logo?.url;
  String? get coverUrl => cover?.url;

  factory BusinessModel.fromJson(Map<String, dynamic> json) {
    FileResponseDto? parseFile(dynamic fileJson) {
      if (fileJson == null) return null;
      if (fileJson is Map<String, dynamic>) {
        return FileResponseDto.fromJson(fileJson);
      }
      if (fileJson is String) {
        return FileResponseDto(url: fileJson);
      }
      return null;
    }

    return BusinessModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      rfc: json['rfc'] as String? ?? '',
      establishmentDate: json['establishmentDate']?.toString(),
      active: json['active'] as bool? ?? true,
      industry: json['industry'] != null && json['industry'] is Map<String, dynamic>
          ? IndustriesModel.fromJson(json['industry'] as Map<String, dynamic>)
          : null,
      businessesType: json['businessesType'] != null && json['businessesType'] is Map<String, dynamic>
          ? BusinessesTypeModel.fromJson(json['businessesType'] as Map<String, dynamic>)
          : null,
      taxRegimen: json['taxRegimen'] != null && json['taxRegimen'] is Map<String, dynamic>
          ? TypesRegimensTaxesModel.fromJson(json['taxRegimen'] as Map<String, dynamic>)
          : null,
      logo: parseFile(json['logo']),
      cover: parseFile(json['cover']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'rfc': rfc,
      if (establishmentDate != null) 'establishmentDate': establishmentDate,
      'active': active,
      if (industry != null) 'industry': industry!.toJson(),
      if (businessesType != null) 'businessesType': businessesType!.toJson(),
      if (taxRegimen != null) 'taxRegimen': taxRegimen!.toJson(),
      if (logo != null) 'logo': logo!.toJson(),
      if (cover != null) 'cover': cover!.toJson(),
    };
  }
}
