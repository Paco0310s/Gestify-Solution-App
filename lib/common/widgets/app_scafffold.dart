import 'package:flutter/material.dart';
import 'package:gestify_solution/common/widgets/app_text.dart';
import 'package:gestify_solution/common/widgets/responsive.dart';

class AppScaffold extends StatelessWidget {
  final bool showAppBar;
  final String title;
  final Widget mobile;
  final Widget? mobileWhenIsLoading;
  final Widget tablet;
  final Widget? tabletWhenIsLoading;
  final Widget desktop;
  final Widget? desktopWhenIsLoading;
  final bool isLoading;

  const AppScaffold({
    super.key,
    this.showAppBar = true,
    required this.title,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    this.mobileWhenIsLoading,
    this.tabletWhenIsLoading,
    this.desktopWhenIsLoading,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar ? AppBar(title: AppText(title)) : null,
      body: SafeArea(
        child: Responsive(
          mobile: mobile,
          mobileWhenIsLoading: mobileWhenIsLoading,
          tablet: tablet,
          tabletWhenIsLoading: tabletWhenIsLoading,
          desktop: desktop,
          desktopWhenIsLoading: desktopWhenIsLoading,
          isLoading: isLoading,
        ),
      ),
    );
  }
}
