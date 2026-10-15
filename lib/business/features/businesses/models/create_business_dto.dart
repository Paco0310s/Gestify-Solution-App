import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

class CreateBusinessDto {
  final String name;
  final String? description;
  final String rfc;
  final String establishmentDate; // Format: yyyy-MM-dd
  final int industryId;
  final int businessesTypeId;
  final int taxRegimenId;
  final XFile? logo;
  final XFile? cover;
  final Uint8List? logoBytes;
  final Uint8List? coverBytes;
  final String? logoName;
  final String? coverName;

  CreateBusinessDto({
    required this.name,
    this.description,
    required this.rfc,
    required this.establishmentDate,
    required this.industryId,
    required this.businessesTypeId,
    required this.taxRegimenId,
    this.logo,
    this.cover,
    this.logoBytes,
    this.coverBytes,
    this.logoName,
    this.coverName,
  });

  /// Converts DTO to Multipart FormData for backend upload
  Future<FormData> toFormData() async {
    final Map<String, dynamic> data = {
      'name': name.trim(),
      if (description != null && description!.trim().isNotEmpty)
        'description': description!.trim(),
      'rfc': rfc.trim().toUpperCase(),
      'establishmentDate': establishmentDate.trim(),
      // Spring custom deserializers expect the integer ID
      'industry': industryId,
      'businessesType': businessesTypeId,
      'taxRegimen': taxRegimenId,
    };

    Uint8List? resolvedLogoBytes = logoBytes;
    if (resolvedLogoBytes == null && logo != null) {
      try {
        resolvedLogoBytes = await logo!.readAsBytes();
      } catch (_) {}
    }

    if (resolvedLogoBytes != null) {
      final fileName = logoName ?? (logo?.name.isNotEmpty == true ? logo!.name : 'logo.jpg');
      data['logo'] = MultipartFile.fromBytes(
        resolvedLogoBytes,
        filename: fileName,
      );
    }

    Uint8List? resolvedCoverBytes = coverBytes;
    if (resolvedCoverBytes == null && cover != null) {
      try {
        resolvedCoverBytes = await cover!.readAsBytes();
      } catch (_) {}
    }

    if (resolvedCoverBytes != null) {
      final fileName = coverName ?? (cover?.name.isNotEmpty == true ? cover!.name : 'cover.jpg');
      data['cover'] = MultipartFile.fromBytes(
        resolvedCoverBytes,
        filename: fileName,
      );
    }

    return FormData.fromMap(data);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'rfc': rfc,
      'establishmentDate': establishmentDate,
      'industry': industryId,
      'businessesType': businessesTypeId,
      'taxRegimen': taxRegimenId,
    };
  }
}

