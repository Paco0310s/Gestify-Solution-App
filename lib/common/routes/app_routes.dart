import 'package:flutter/material.dart';
import 'package:gestify_solution/business/features/businesses/business_add_screen.dart';
import 'package:gestify_solution/business/features/businesses/businesses_screen.dart';
import 'package:gestify_solution/business/features/dashboard/dashboard_screen.dart';
import 'package:gestify_solution/business/features/forgot_password/forgot_password_screen.dart';
import 'package:gestify_solution/business/features/sign_in/sign_in_screen.dart';
import 'package:gestify_solution/business/features/sign_up/sign_up_screen.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/features/offline/offline_screen.dart';
import 'package:gestify_solution/common/features/splash/splash_screen.dart';
import 'routes.dart';

class AppRoutes {
  Map<String, Widget Function(BuildContext)> get routes {
    return {
      Routes.splash: (context) => const SplashScreen(),
      Routes.signIn: (context) => const SignInScreen(),
      Routes.dashboard: (context) => DashboardScreen(title: AppTexts.dashboardTitle),
      Routes.businesses: (context) => BusinessesScreen(title: AppTexts.businessesTitle),
      Routes.offline: (context) => const OfflineScreen(),
      Routes.signUp: (context) => const SignUpScreen(),
      Routes.forgotPassword: (context) => const ForgotPasswordScreen(),
      Routes.businessAdd: (context) => BusinessAddScreen(title: AppTexts.addBusinessButton),
    };
  }
}
