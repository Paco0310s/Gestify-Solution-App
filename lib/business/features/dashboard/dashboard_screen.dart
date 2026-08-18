import 'package:flutter/material.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/widgets/app_dashboard_layout.dart';

class DashboardScreen extends StatelessWidget {
  final String title;
  const DashboardScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppDashboardLayout(
      title: title,
      mobileChild: Center(child: Text(AppTexts.mobileView)),
      tabletChild: Center(child: Text(AppTexts.tabletView)),
      desktopChild: Center(child: Text(AppTexts.desktopView)),
    );
  }
}
