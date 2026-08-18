import 'package:flutter/material.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/utils/snackbar_util.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forgot_password_provider.g.dart';

@riverpod
Future<void> sendResetLink(Ref ref, BuildContext context, String email) async {
  SnackbarUtil.showSuccess(context, '${AppTexts.passwordResetLinkSent} $email');
  NavigationService.replaceWith(context, Routes.signIn);
}
