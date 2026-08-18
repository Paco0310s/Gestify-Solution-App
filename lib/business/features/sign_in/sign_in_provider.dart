import 'package:flutter/material.dart';
import 'package:gestify_solution/business/features/sign_in/sign_in_service.dart';
import 'package:gestify_solution/business/models/logged_boss_model.dart';
import 'package:gestify_solution/business/models/login_boss_dto.dart';
import 'package:gestify_solution/common/constants/app_config.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/errors/http_failure.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/services/storage_service.dart';
import 'package:gestify_solution/common/utils/either.dart';
import 'package:gestify_solution/common/utils/snackbar_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_provider.g.dart';

@riverpod
Future<void> signIn(Ref ref, BuildContext context, LoginBossDto loginDto) async {
  final EitherUtil<HttpFailure, LoggedBossModel> userDataResponse = await SignInService.signIn(loginDto);

  userDataResponse.when(
    (failure) {
      SnackbarUtil.showError(context, failure.message);
    },
    (user) {
      StorageService.setString(AppConfig.accessTokenKey, user.accessToken);
      StorageService.setString(AppConfig.refreshTokenKey, user.refreshToken);
      SnackbarUtil.showSuccess(context, '${AppTexts.welcome}!');
      NavigationService.replaceWith(context, Routes.dashboard);
    },
  );
}

// {
//     "id": 83,
//     "createdAt": "2026-04-16T16:42:04.674945",
//     "updatedAt": null,
//     "deletedAt": null,
//     "createdBy": "Gestify solution server",
//     "updatedBy": null,
//     "deletedBy": null,
//     "user": {
//         "username": "paco0310",
//         "email": "paco0310s@gmail.com",
//         "firstName": "Paco",
//         "lastName": "Sotelo",
//         "active": true
//     },
//     "phone": "+52 3921234567",
//     "birthdate": "2000-03-10"
// }

@riverpod
class SignInLoading extends _$SignInLoading {
  @override
  bool build() {
    return false; // Initial loading state is false
  }

  void setLoading(bool value) {
    state = value;
  }
}

@riverpod
Future<void> signInWithGoogle(Ref ref, BuildContext context) async {
  SnackbarUtil.showInfo(context, AppTexts.isNotImplemented);
}

@riverpod
Future<void> signInWithApple(Ref ref, BuildContext context) async {
  SnackbarUtil.showInfo(context, AppTexts.isNotImplemented);
}

@riverpod
Future<void> goToSignUp(Ref ref, BuildContext context) async {
  NavigationService.replaceWith(context, Routes.signUp);
}

@riverpod
Future<void> goToForgotPassword(Ref ref, BuildContext context) async {
  NavigationService.replaceWith(context, Routes.forgotPassword);
}

@riverpod
class RememberMe extends _$RememberMe {
  @override
  bool build() {
    return false; // Default value for "Remember Me" is false
  }

  void toggle() {
    state = !state; // Toggle the boolean value
  }
}
