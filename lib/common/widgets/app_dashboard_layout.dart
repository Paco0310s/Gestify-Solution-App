import 'package:flutter/material.dart';
import 'package:gestify_solution/common/features/side_menu/app_side_menu.dart';
import 'package:gestify_solution/common/widgets/app_dashboard_header.dart';
import 'package:gestify_solution/common/widgets/responsive.dart';

class AppDashboardLayout extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget mobileChild;
  final Widget? mobileChildWhenIsLoading;
  final Widget tabletChild;
  final Widget? tabletChildWhenIsLoading;
  final Widget desktopChild;
  final Widget? desktopChildWhenIsLoading;
  final bool showDrawerButton;
  final List<Widget>? headerActions;

  const AppDashboardLayout({
    super.key,
    required this.title,
    this.subtitle,
    required this.mobileChild,
    this.mobileChildWhenIsLoading,
    required this.tabletChild,
    this.tabletChildWhenIsLoading,
    required this.desktopChild,
    this.desktopChildWhenIsLoading,
    this.showDrawerButton = true,
    this.headerActions,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: AppDashboardLayoutMobile(
        title: title,
        subtitle: subtitle,
        showDrawerButton: showDrawerButton,
        actions: headerActions,
        child: mobileChild,
      ),
      mobileWhenIsLoading: AppDashboardLayoutMobile(
        title: title,
        subtitle: subtitle,
        showDrawerButton: showDrawerButton,
        actions: headerActions,
        child: mobileChildWhenIsLoading ?? mobileChild,
      ),
      tablet: AppDashboardLayoutTablet(
        title: title,
        subtitle: subtitle,
        showDrawerButton: showDrawerButton,
        actions: headerActions,
        child: tabletChild,
      ),
      tabletWhenIsLoading: AppDashboardLayoutTablet(
        title: title,
        subtitle: subtitle,
        showDrawerButton: showDrawerButton,
        actions: headerActions,
        child: tabletChildWhenIsLoading ?? tabletChild,
      ),
      desktop: AppDashboardLayoutDesktop(
        title: title,
        subtitle: subtitle,
        actions: headerActions,
        child: desktopChild,
      ),
      desktopWhenIsLoading: AppDashboardLayoutDesktop(
        title: title,
        subtitle: subtitle,
        actions: headerActions,
        child: desktopChildWhenIsLoading ?? desktopChild,
      ),
    );
  }
}

class AppDashboardLayoutDesktop extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget child;

  const AppDashboardLayoutDesktop({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppSideMenu(),
            Expanded(
              child: Column(
                children: [
                  AppDashboardHeader(
                    title: title,
                    subtitle: subtitle,
                    actions: actions,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: child,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppDashboardLayoutTablet extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget child;
  final bool showDrawerButton;

  const AppDashboardLayoutTablet({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    required this.child,
    required this.showDrawerButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppDashboardHeader(
        title: title,
        subtitle: subtitle,
        actions: actions,
        showSearch: false,
      ),
      drawer: showDrawerButton ? const AppSideMenu() : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }
}

class AppDashboardLayoutMobile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final Widget child;
  final bool showDrawerButton;

  const AppDashboardLayoutMobile({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    required this.child,
    required this.showDrawerButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppDashboardHeader(
        title: title,
        subtitle: subtitle,
        actions: actions,
        showSearch: false,
      ),
      drawer: showDrawerButton ? const AppSideMenu() : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: child,
        ),
      ),
    );
  }
}
