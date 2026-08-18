import 'package:flutter/material.dart';
import 'package:gestify_solution/common/models/files/adapted_file.dart';

class AssetFile extends AdaptedFile {
  final String assetPath; // Asset path for the image, e.g., 'assets/images/photo.png'

  AssetFile({required this.assetPath, super.key});

  @override
  Widget getWidget({BoxFit fit = BoxFit.cover, double? width, double? height}) {
    return Image.asset(assetPath, fit: fit, width: width, height: height);
  }

  @override
  String getSourceDescription() => 'Asset File: $assetPath';
}
