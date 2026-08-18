import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gestify_solution/common/models/files/adapted_file.dart';

class LocalFile extends AdaptedFile {
  final String localPath;

  LocalFile({required this.localPath, super.key});

  @override
  Widget getWidget({BoxFit fit = BoxFit.cover, double? width, double? height}) {
    return Image.file(File(localPath), fit: fit, width: width, height: height);
  }

  @override
  String getSourceDescription() => 'Local File: $localPath';
}
