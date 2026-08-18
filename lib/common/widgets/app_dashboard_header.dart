import 'package:flutter/material.dart';

class AppDashboardHeader extends StatelessWidget {
  final String title;
  final Widget? leading;
  final List<Widget>? actions;

  const AppDashboardHeader({super.key, required this.title, this.leading, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: leading,
      title: Text(title),
      actions: actions,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 2,
      shadowColor: Colors.black26,
    );
  }
}
