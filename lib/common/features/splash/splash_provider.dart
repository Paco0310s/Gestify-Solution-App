import 'package:flutter/material.dart';
import 'package:gestify_solution/business/features/sign_in/sign_in_service.dart';
import 'package:gestify_solution/business/models/logged_boss_model.dart';
import 'package:gestify_solution/common/constants/app_config.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/errors/http_failure.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:gestify_solution/common/services/connectivity_service.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/services/storage_service.dart';
import 'package:gestify_solution/common/utils/either.dart';
import 'package:gestify_solution/common/utils/snackbar_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'splash_provider.g.dart';

@riverpod
Future<void> splashStartupLogic(Ref ref, BuildContext context) async {
  final hasInternet = await ConnectivityService.hasInternet();

  if (!hasInternet) {
    if (context.mounted) NavigationService.replaceWith(context, Routes.offline);
    return;
  }

  final bool isSignedIn = await SignInService.isSignedIn();

  if (!isSignedIn) {
    if (context.mounted) NavigationService.replaceWith(context, Routes.signIn);
    return;
  }

  final EitherUtil<HttpFailure, bool> isValidTokenResponse = await SignInService.validToken();

  isValidTokenResponse.when(
    (failure) {
      SnackbarUtil.showError(context, failure.message);
      if (context.mounted) NavigationService.replaceWith(context, Routes.signIn);
    },
    (isValid) async {
      final EitherUtil<HttpFailure, LoggedBossModel> refreshTokenResponse = await SignInService.refreshToken();
      refreshTokenResponse.when(
        (failure) {
          SnackbarUtil.showError(context, failure.message);
          if (context.mounted) NavigationService.replaceWith(context, Routes.signIn);
        },
        (loggedBoss) {
          StorageService.setString(AppConfig.accessTokenKey, loggedBoss.accessToken);
          StorageService.setString(AppConfig.refreshTokenKey, loggedBoss.refreshToken);
          StorageService.getUsername();

          SnackbarUtil.showSuccess(context, AppTexts.welcome);
          NavigationService.replaceWith(context, Routes.dashboard);
        },
      );
    },
  );
}

@riverpod
class SplashLoading extends _$SplashLoading {
  @override
  bool build() {
    return false;
  }

  void setLoading(bool value) {
    state = value;
  }
}
