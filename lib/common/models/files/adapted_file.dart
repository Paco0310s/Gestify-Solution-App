import 'package:flutter/material.dart';
import 'package:gestify_solution/common/models/files/asset_file.dart';
import 'package:gestify_solution/common/models/files/local_file.dart';
import 'package:gestify_solution/common/models/files/network_file.dart';
import 'package:gestify_solution/common/models/files/svg_file.dart';
import 'package:image_picker/image_picker.dart';

abstract class AdaptedFile {
  final Key? key; // Unique identifier for the file, useful for widget keys

  AdaptedFile({this.key});

  /// Abstract method to get a widget representation
  Widget getWidget({BoxFit fit = BoxFit.cover, double? width, double? height});

  String getSourceDescription();

  static AssetFile asset(String assetPath) {
    return AssetFile(assetPath: assetPath);
  }

  static LocalFile local(String localPath) {
    return LocalFile(localPath: localPath);
  }

  static NetworkFile network(String url) {
    return NetworkFile(url: url);
  }

  static PickedFile picked(String path) {
    return PickedFile(path);
  }

  static SvgFile svg(String assetPath, {ColorFilter? colorFilter}) {
    return SvgFile(assetPath: assetPath, colorFilter: colorFilter);
  }

  static AdaptedFile from(AdaptedFile file) {
    return file;
  }
}
