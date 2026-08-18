import 'package:flutter/material.dart';
import 'package:gestify_solution/business/features/sign_in/sign_in_service.dart';
import 'package:gestify_solution/business/features/sign_up/sign_up_service.dart';
import 'package:gestify_solution/business/models/create_boss_dto.dart';
import 'package:gestify_solution/business/models/created_boss_model.dart';
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

part 'sign_up_provider.g.dart';

@riverpod
Future<void> goToSignIn(Ref ref, BuildContext context) async {
  NavigationService.replaceWith(context, Routes.signIn);
}

@riverpod
Future<void> signUp(Ref ref, BuildContext context, CreateBossDto createBossDto) async {
  final EitherUtil<HttpFailure, CreatedBossModel> userDataResponse = await SignUpService.signUp(createBossDto);

  userDataResponse.when(
    (failure) {
      SnackbarUtil.showError(context, failure.message);
    },
    (createdBoss) async {
      final EitherUtil<HttpFailure, LoggedBossModel> userDataResponse = await SignInService.signIn(
        LoginBossDto(username: createBossDto.user.email, password: createBossDto.user.password),
      );

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
    },
  );
}

@riverpod
class SignUpLoading extends _$SignUpLoading {
  @override
  bool build() {
    return false; // Initial loading state is false
  }

  void setLoading(bool value) {
    state = value;
  }
}

@riverpod
Future<void> signUpWithGoogle(Ref ref, BuildContext context) async {
  SnackbarUtil.showInfo(context, AppTexts.isNotImplemented);
}

@riverpod
Future<void> signUpWithApple(Ref ref, BuildContext context) async {
  SnackbarUtil.showInfo(context, AppTexts.isNotImplemented);
}
