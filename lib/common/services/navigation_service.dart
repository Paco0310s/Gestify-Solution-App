import 'package:flutter/material.dart';

class NavigationService {
  static Future<void> navigateTo(BuildContext context, String route) async {
    if (context.mounted) {
      Navigator.of(context).pushNamed(route);
    }
  }

  static Future<void> replaceWith(BuildContext context, String route) async {
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed(route);
    }
  }

  static Future<void> replaceUntil(BuildContext context, String route) async {
    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false);
    }
  }
}
