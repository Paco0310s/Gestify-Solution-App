import 'package:flutter/material.dart';

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? mobileWhenIsLoading;
  final Widget tablet;
  final Widget? tabletWhenIsLoading;
  final Widget desktop;
  final Widget? desktopWhenIsLoading;
  final bool isLoading;

  static final double mobileMaxWidth = 650;
  static final double tabletMaxWidth = 1100;

  const Responsive({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
    this.mobileWhenIsLoading,
    this.tabletWhenIsLoading,
    this.desktopWhenIsLoading,
    this.isLoading = false,
  });

  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < mobileMaxWidth;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < tabletMaxWidth && MediaQuery.of(context).size.width >= mobileMaxWidth;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= tabletMaxWidth;

  static double getWidth(BuildContext context) => MediaQuery.of(context).size.width;

  static double getHeight(BuildContext context) => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      if (isDesktop(context)) {
        return desktopWhenIsLoading ?? desktop;
      } else if (isTablet(context)) {
        return tabletWhenIsLoading ?? tablet;
      } else {
        return mobileWhenIsLoading ?? mobile;
      }
    }

    if (isDesktop(context)) {
      return desktop;
    } else if (isTablet(context)) {
      return tablet;
    } else {
      return mobile;
    }
  }
}
