import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gestify_solution/business/features/sign_in/sign_in_provider.dart';
import 'package:gestify_solution/business/models/login_boss_dto.dart';
import 'package:gestify_solution/common/constants/app_assets.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/models/files/adapted_file.dart';
import 'package:gestify_solution/common/utils/validators.dart';
import 'package:gestify_solution/common/widgets/app_button.dart';
import 'package:gestify_solution/common/widgets/app_divider_with_text.dart';
import 'package:gestify_solution/common/widgets/app_image.dart';
import 'package:gestify_solution/common/widgets/app_password_field.dart';
import 'package:gestify_solution/common/widgets/app_scafffold.dart';
import 'package:gestify_solution/common/widgets/app_text.dart';
import 'package:gestify_solution/common/widgets/app_text_field.dart';

class SignInScreen extends ConsumerWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isLoading = ref.watch(signInLoadingProvider);

    return AppScaffold(
      showAppBar: false,
      title: AppTexts.signIn,
      mobile: SignInMobile(context),
      tablet: SignInTablet(context),
      desktop: SignInDesktop(context),
    );
  }
}

class SignInMobile extends StatelessWidget {
  final BuildContext context;

  const SignInMobile(this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: SignInWidget(ponderContainers: 0, ponderForm: 100));
  }
}

class SignInTablet extends StatelessWidget {
  final BuildContext context;

  const SignInTablet(this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(flex: 100, child: SignInWidget(ponderContainers: 10, ponderForm: 90)),
        // Flexible(flex: 30, child: SignInImage()),
      ],
    );
  }
}

class SignInDesktop extends StatelessWidget {
  final BuildContext context;

  const SignInDesktop(this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(flex: 45, child: SignInWidget()),
        Flexible(flex: 55, child: SignInImage()),
      ],
    );
  }
}

class SignInImage extends StatelessWidget {
  const SignInImage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppImage(AdaptedFile.svg(AppAssets.signIn), color: AppColors.kNeutral100, height: double.infinity, width: double.infinity, fit: BoxFit.contain);
  }
}

class SignInWidget extends StatelessWidget {
  final int ponderContainers;
  final int ponderForm;

  const SignInWidget({super.key, this.ponderContainers = 20, this.ponderForm = 60});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Flexible(flex: ponderContainers, child: Container()),
            Flexible(flex: ponderForm, child: SignInForm()),
            Flexible(flex: ponderContainers, child: Container()),
          ],
        ),
      ),
    );
  }
}

class SignInForm extends ConsumerStatefulWidget {
  const SignInForm({super.key});

  @override
  ConsumerState<SignInForm> createState() => _SignInFormState();
}

class _SignInFormState extends ConsumerState<SignInForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() async {
    if (_formKey.currentState?.validate() ?? false) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text;

      final LoginBossDto loginBossDto = LoginBossDto(username: username, password: password);

      ref.read(signInLoadingProvider.notifier).setLoading(true);
      await ref.read(signInProvider(context, loginBossDto).future);
      ref.read(signInLoadingProvider.notifier).setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signInLoadingProvider);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AbsorbPointer(
        absorbing: isLoading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImage(AdaptedFile.asset(AppAssets.logo), height: 100, width: 100),
            Gap(10),
            AppText(AppTexts.signIn, fontSize: 22, fontWeight: FontWeight.bold),
            Gap(10),
            RichText(
              text: TextSpan(
                text: AppTexts.needAccount,
                style: TextStyle(fontSize: 16, color: AppColors.kDark3),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()..onTap = () => ref.read(goToSignUpProvider(context)),
                    text: ' ${AppTexts.registerHere}',
                    style: TextStyle(fontSize: 16, color: AppColors.kPrimary500),
                  ),
                ],
              ),
            ),
            // Gap(20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Flexible(flex: 48, child: ButtonGoogle()),
            //     Flexible(flex: 4, child: Container()),
            //     Flexible(flex: 48, child: ButtonApple()),
            //   ],
            // ),
            Gap(20),
            AppDividerWithText(text: AppTexts.orDivider),
            Gap(5),
            AppTextField(
              text: AppTexts.emailLabel,
              hintText: AppTexts.emailHint,
              keyboardType: TextInputType.emailAddress,
              textColor: AppColors.kDark3,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              controller: _usernameController,
              validator: (value) => ValidatorsUtil.validateEmail(value),
            ),
            Gap(20),
            AppPasswordField(
              text: AppTexts.passwordLabel,
              hintText: AppTexts.passwordHint,
              keyboardType: TextInputType.visiblePassword,
              textColor: AppColors.kDark3,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              controller: _passwordController,
              validator: (value) => ValidatorsUtil.validatePassword(value),
            ),
            Gap(20),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Checkbox(
            //       value: ref.watch(rememberMeProvider),
            //       onChanged: (value) {
            //         ref.read(rememberMeProvider.notifier).toggle();
            //       },
            //     ),
            //     AppText(AppTexts.rememberMe, fontSize: 14, color: AppColors.kDark3),
            //     Spacer(),
            //     AppTapText(text: AppTexts.forgotPasswordTitle, onTap: () => ref.read(goToForgotPasswordProvider(context))),
            //   ],
            // ),
            // Gap(10),
            AppButton(
              leadingWidget: Icon(Icons.login, size: 20, color: AppColors.kWhiteColor),
              text: AppTexts.signIn,
              onPressed: _handleSignIn,
              width: double.infinity,
              height: 50,
              backgroundColor: AppColors.kPrimary500,
              textColor: AppColors.kWhiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              isLoading: isLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonApple extends ConsumerWidget {
  const ButtonApple({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isLoading = ref.watch(signInLoadingProvider);

    return AppButton(
      text: 'Use Apple',
      onPressed: () => ref.read(signInWithAppleProvider(context)),
      backgroundColor: AppColors.kWhiteColor,
      textColor: AppColors.kDark3,
      fontSize: 12,
      leadingWidget: AppImage(AdaptedFile.svg(AppAssets.appleIcon), height: 20, width: 20, fit: BoxFit.contain),
      width: double.infinity,
      borderColor: AppColors.kNeutral300,
      fontWeight: FontWeight.w600,
      isLoading: false,
    );
  }
}

class ButtonGoogle extends ConsumerWidget {
  const ButtonGoogle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isLoading = ref.watch(signInLoadingProvider);

    return AppButton(
      text: AppTexts.googleSignInButton,
      onPressed: () => ref.read(signInWithGoogleProvider(context)),
      backgroundColor: AppColors.kWhiteColor,
      textColor: AppColors.kDark3,
      fontSize: 12,
      leadingWidget: AppImage(AdaptedFile.svg(AppAssets.googleIcon), height: 20, width: 20, fit: BoxFit.contain),
      borderColor: AppColors.kNeutral300,
      fontWeight: FontWeight.w600,
      isLoading: false,
    );
  }
}
