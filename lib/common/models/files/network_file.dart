import 'package:flutter/material.dart';
import 'package:gestify_solution/common/models/files/adapted_file.dart';

class NetworkFile extends AdaptedFile {
  final String url;

  NetworkFile({required this.url, super.key});

  @override
  Widget getWidget({BoxFit fit = BoxFit.cover, double? width, double? height}) {
    return Image.network(url, fit: fit, width: width, height: height);
  }

  @override
  String getSourceDescription() => 'Network File: $url';
}
