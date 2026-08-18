import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gestify_solution/business/features/sign_in/sign_in_service.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:gestify_solution/common/constants/app_config.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/errors/http_failure.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/services/storage_service.dart';
import 'package:gestify_solution/common/utils/either.dart';
import 'package:gestify_solution/common/utils/snackbar_util.dart';
import 'package:gestify_solution/common/widgets/app_dashboard_header.dart';
import 'package:gestify_solution/common/features/side_menu/app_side_menu.dart';
import 'package:gestify_solution/common/widgets/app_text.dart';
import 'package:gestify_solution/common/widgets/responsive.dart';

class AppDashboardLayout extends StatelessWidget {
  final String title;
  final Widget mobileChild;
  final Widget? mobileChildWhenIsLoading;
  final Widget tabletChild;
  final Widget? tabletChildWhenIsLoading;
  final Widget desktopChild;
  final Widget? desktopChildWhenIsLoading;
  final bool showDrawerButton;

  const AppDashboardLayout({
    super.key,
    required this.title,
    required this.mobileChild,
    this.mobileChildWhenIsLoading,
    required this.tabletChild,
    this.tabletChildWhenIsLoading,
    required this.desktopChild,
    this.desktopChildWhenIsLoading,
    this.showDrawerButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Responsive(
      mobile: AppDashboardLayoutMobile(title: title, showDrawerButton: showDrawerButton, child: mobileChild),
      mobileWhenIsLoading: AppDashboardLayoutMobile(title: title, showDrawerButton: showDrawerButton, child: mobileChildWhenIsLoading ?? mobileChild),
      tablet: AppDashboardLayoutTablet(title: title, showDrawerButton: showDrawerButton, child: tabletChild),
      tabletWhenIsLoading: AppDashboardLayoutTablet(title: title, showDrawerButton: showDrawerButton, child: tabletChildWhenIsLoading ?? tabletChild),
      desktop: AppDashboardLayoutDesktop(title: title, child: desktopChild),
      desktopWhenIsLoading: AppDashboardLayoutDesktop(title: title, child: desktopChildWhenIsLoading ?? desktopChild),
    );
  }
}

class AppDashboardLayoutDesktop extends StatelessWidget {
  final String title;
  final Widget child;
  const AppDashboardLayoutDesktop({super.key, required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSideMenu(),
            Expanded(
              child: Column(
                children: [
                  AppDashboardHeader(
                    title: title,
                    actions: [
                      // DropdownButton2<Locale>(
                      //   underline: const SizedBox.shrink(),
                      //   isDense: true,
                      //   isExpanded: true,
                      //   customButton: OutlinedDropdownButton(child: Text(AppTexts.languageEnglish)),
                      //   items: [
                      //     DropdownItem(value: Locale('en', 'US'), child: Text(AppTexts.languageEnglish)),
                      //     DropdownItem(value: Locale('es', 'ES'), child: Text(AppTexts.languageSpanish)),
                      //   ],
                      //   onChanged: (value) {
                      //     // Handle language change
                      //   },
                      //   dropdownStyleData: DropdownStyleData(
                      //     width: 100,
                      //     padding: null,
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(4),
                      //       color: Colors.white,
                      //       boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                      //     ),
                      //     elevation: 8,
                      //     offset: Offset(0, 8),
                      //     scrollbarTheme: ScrollbarThemeData(
                      //       radius: Radius.circular(40),
                      //       thickness: WidgetStateProperty.all(6),
                      //       thumbVisibility: WidgetStateProperty.all(true),
                      //     ),
                      //   ),
                      //   menuItemStyleData: MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16)),
                      //   // value: Locale('en', 'US'),
                      //   iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black54)),
                      // ),
                      SizedBox(width: 16),
                      // OutlinedDropdownButton(
                      //   trailingIcon: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black54),
                      //   child: Row(
                      //     children: [
                      //       CircleAvatar(radius: 12, child: Icon(Icons.person, size: 16)),
                      //       SizedBox(width: 8),
                      //       Text(AppTexts.user),
                      //     ],
                      //   ),
                      // ),
                      DropdownButton2<String>(
                        underline: const SizedBox.shrink(),
                        isDense: true,
                        isExpanded: true,
                        customButton: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(radius: 30, child: Icon(Icons.person, size: 24)),
                        ),
                        items: [
                          DropdownItem(value: 'profile', child: const Text(AppTexts.profile)),
                          DropdownItem(value: 'settings', child: const Text(AppTexts.settings)),
                          DropdownItem(value: 'logout', child: const Text(AppTexts.logout)),
                        ],
                        onChanged: (value) async {
                          // Handle menu actions
                          if (value == 'logout') {
                            final EitherUtil<HttpFailure, void> refreshTokenResponse = await SignInService.logout();

                            refreshTokenResponse.when(
                              (failure) {
                                SnackbarUtil.showError(context, failure.message);
                              },
                              (_) {
                                StorageService.remove(AppConfig.accessTokenKey);
                                StorageService.remove(AppConfig.refreshTokenKey);
                                SnackbarUtil.showSuccess(context, AppTexts.loggedOut);
                                NavigationService.replaceWith(context, Routes.signIn);
                              },
                            );
                          }
                        },
                        dropdownStyleData: DropdownStyleData(
                          width: 150,
                          padding: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))],
                          ),
                          elevation: 8,
                          offset: Offset(0, 8),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: Radius.circular(40),
                            thickness: WidgetStateProperty.all(6),
                            thumbVisibility: WidgetStateProperty.all(true),
                          ),
                        ),
                        menuItemStyleData: MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16)),
                      ),
                      SizedBox(width: 16),
                    ],
                  ),
                  Expanded(
                    child: Padding(padding: const EdgeInsets.all(14), child: child),
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
  final Widget child;
  final bool showDrawerButton;

  const AppDashboardLayoutTablet({super.key, required this.title, required this.child, required this.showDrawerButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(title, color: AppColors.kNeutral100, fontSize: 18, fontWeight: FontWeight.w600),
        backgroundColor: AppColors.kPrimary800,
        iconTheme: IconThemeData(color: AppColors.kNeutral100),
      ),
      drawer: showDrawerButton ? AppSideMenu() : null,
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(12), child: child),
      ),
    );
  }
}

class AppDashboardLayoutMobile extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showDrawerButton;

  const AppDashboardLayoutMobile({super.key, required this.title, required this.child, required this.showDrawerButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(title, color: AppColors.kNeutral100, fontSize: 18, fontWeight: FontWeight.w600),
        backgroundColor: AppColors.kPrimary800,
        iconTheme: IconThemeData(color: AppColors.kNeutral100),
      ),
      drawer: showDrawerButton ? AppSideMenu() : null,
      body: SafeArea(
        child: Padding(padding: const EdgeInsets.all(8), child: child),
      ),
    );
  }
}

class OutlinedDropdownButton extends StatelessWidget {
  const OutlinedDropdownButton({
    super.key,
    this.child,
    this.trailingIcon,
    this.decoration,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  });

  final Widget? child;
  final Widget? trailingIcon;
  final BoxDecoration? decoration;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final _dropdownStyle = AcnooDropdownStyle(context);

    final mqSize = MediaQuery.sizeOf(context);

    final decoration =
        this.decoration ??
        BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: theme.colorScheme.outline),
        );

    return Container(
      padding: padding,
      decoration: decoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(child: child ?? const SizedBox.shrink()),
          SizedBox(width: mqSize.width >= 480 ? 8 : 4),
          // trailingIcon ?? _dropdownStyle.iconStyle.icon,
        ],
      ),
    );
  }
}
