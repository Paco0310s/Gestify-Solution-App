import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:gestify_solution/business/features/sign_up/sign_up_provider.dart';
import 'package:gestify_solution/business/models/create_boss_dto.dart';
import 'package:gestify_solution/common/constants/app_assets.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/models/files/adapted_file.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:gestify_solution/common/services/navigation_service.dart';
import 'package:gestify_solution/common/utils/validators.dart';
import 'package:gestify_solution/common/widgets/app_button.dart';
import 'package:gestify_solution/common/widgets/app_image.dart';
import 'package:gestify_solution/common/widgets/app_password_field.dart';
import 'package:gestify_solution/common/widgets/app_phone_field.dart';
import 'package:gestify_solution/common/widgets/app_scafffold.dart';
import 'package:gestify_solution/common/widgets/app_text.dart';
import 'package:gestify_solution/common/widgets/responsive.dart';
import 'package:intl/intl.dart';

import '../../../common/widgets/app_divider_with_text.dart';
import '../../../common/widgets/app_text_field.dart';

class SignUpScreen extends ConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      showAppBar: false,
      title: AppTexts.signUp,
      mobile: SignUpMobile(context),
      tablet: SignUpTablet(context),
      desktop: SignUpDesktop(context),
    );
  }
}

class SignUpMobile extends StatelessWidget {
  final BuildContext context;

  const SignUpMobile(this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: SignUpWidget(ponderContainers: 0, ponderForm: 100));
  }
}

class SignUpTablet extends StatelessWidget {
  final BuildContext context;

  const SignUpTablet(this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(flex: 100, child: SignUpWidget(ponderContainers: 10, ponderForm: 90)),
        // Flexible(flex: 30, child: SignUpImage()),
      ],
    );
  }
}

class SignUpDesktop extends StatelessWidget {
  final BuildContext context;

  const SignUpDesktop(this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(flex: 45, child: SignUpWidget()),
        Flexible(flex: 55, child: SignUpImage()),
      ],
    );
  }
}

class SignUpImage extends StatelessWidget {
  const SignUpImage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppImage(AdaptedFile.svg(AppAssets.signUp), color: AppColors.kNeutral100, height: double.infinity, width: double.infinity, fit: BoxFit.contain);
  }
}

class SignUpWidget extends StatelessWidget {
  final int ponderContainers;
  final int ponderForm;

  const SignUpWidget({super.key, this.ponderContainers = 10, this.ponderForm = 80});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Row(
          children: [
            Flexible(flex: ponderContainers, child: Container()),
            Flexible(flex: ponderForm, child: SignUpForm()),
            Flexible(flex: ponderContainers, child: Container()),
          ],
        ),
      ),
    );
  }
}

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _countryCodeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _birthdateController.dispose();
    _countryCodeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String firstName = _firstNameController.text.trim();
      final String lastName = _lastNameController.text.trim();
      final String username = _usernameController.text.trim();
      final String birthdate = _birthdateController.text.trim();
      final String countryCode = _countryCodeController.text.isNotEmpty ? _countryCodeController.text.trim() : '52'; // Default a México
      final String phone = '+$countryCode ${_phoneController.text.trim()}';
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      CreateBossDto createBossDto = CreateBossDto(
        user: User(username: username, email: email, firstName: firstName, lastName: lastName, password: password),
        phone: phone,
        birthdate: birthdate,
      );

      ref.read(signUpLoadingProvider.notifier).setLoading(true);
      await ref.read(signUpProvider(context, createBossDto).future);
      ref.read(signUpLoadingProvider.notifier).setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSignUpLoading = ref.watch(signUpLoadingProvider);

    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AbsorbPointer(
        absorbing: isSignUpLoading,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppImage(AdaptedFile.asset(AppAssets.logo), height: 100, width: 100),
            Gap(10),
            AppText(AppTexts.signUp, fontSize: 22, fontWeight: FontWeight.bold),
            Gap(10),
            RichText(
              text: TextSpan(
                text: AppTexts.haveAccount,
                style: TextStyle(fontSize: 16, color: AppColors.kDark3),
                children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        NavigationService.replaceUntil(context, Routes.signIn);
                      },
                    text: ' ${AppTexts.signIn}',
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
            Builder(
              builder: (context) {
                if (!Responsive.isDesktop(context)) {
                  return Column(
                    children: [
                      AppTextField(
                        text: AppTexts.firstNameLabel,
                        hintText: AppTexts.firstNameHint,
                        keyboardType: TextInputType.name,
                        textColor: AppColors.kDark3,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        controller: _firstNameController,
                        validator: (value) => ValidatorsUtil.validateName(value),
                      ),
                      Gap(10),
                      AppTextField(
                        text: AppTexts.lastNameLabel,
                        hintText: AppTexts.lastNameHint,
                        keyboardType: TextInputType.name,
                        textColor: AppColors.kDark3,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        controller: _lastNameController,
                        validator: (value) => ValidatorsUtil.validateLastName(value),
                      ),
                      Gap(10),
                      AppTextField(
                        text: AppTexts.usernameLabel,
                        hintText: AppTexts.usernameHint,
                        keyboardType: TextInputType.text,
                        textColor: AppColors.kDark3,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        controller: _usernameController,
                        validator: (value) => ValidatorsUtil.validateUsername(value),
                      ),
                      Gap(10),
                      AppTextField(
                        text: AppTexts.emailLabel,
                        hintText: AppTexts.emailHint,
                        keyboardType: TextInputType.emailAddress,
                        textColor: AppColors.kDark3,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        controller: _emailController,
                        validator: (value) => ValidatorsUtil.validateEmail(value),
                      ),
                      Gap(10),
                      AppPhoneField(
                        text: AppTexts.phoneLabel,
                        hintTextCode: AppTexts.codeExample,
                        hintTextPhone: AppTexts.phoneHint,
                        textColor: AppColors.kDark3,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        controllerCode: _countryCodeController,
                        controllerPhone: _phoneController,
                      ),
                      Gap(10),
                      _AppBirthdayPicker(birthdateController: _birthdateController),
                      Gap(10),
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
                    ],
                  );
                }
                return GridView(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2.3),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    AppTextField(
                      text: AppTexts.firstNameLabel,
                      hintText: AppTexts.firstNameHint,
                      keyboardType: TextInputType.name,
                      textColor: AppColors.kDark3,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      controller: _firstNameController,
                      validator: (value) => ValidatorsUtil.validateName(value),
                    ),
                    AppTextField(
                      text: AppTexts.lastNameLabel,
                      hintText: AppTexts.lastNameHint,
                      keyboardType: TextInputType.name,
                      textColor: AppColors.kDark3,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      controller: _lastNameController,
                      validator: (value) => ValidatorsUtil.validateLastName(value),
                    ),
                    AppTextField(
                      text: AppTexts.usernameLabel,
                      hintText: AppTexts.usernameHint,
                      keyboardType: TextInputType.text,
                      textColor: AppColors.kDark3,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      controller: _usernameController,
                      validator: (value) => ValidatorsUtil.validateUsername(value),
                    ),
                    AppTextField(
                      text: AppTexts.emailLabel,
                      hintText: AppTexts.emailHint,
                      keyboardType: TextInputType.emailAddress,
                      textColor: AppColors.kDark3,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      controller: _emailController,
                      validator: (value) => ValidatorsUtil.validateEmail(value),
                    ),
                    AppPhoneField(
                      text: AppTexts.phoneLabel,
                      hintTextCode: AppTexts.codeExample,
                      hintTextPhone: AppTexts.phoneHint,
                      textColor: AppColors.kDark3,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      controllerCode: _countryCodeController,
                      controllerPhone: _phoneController,
                    ),
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
                    _AppBirthdayPicker(birthdateController: _birthdateController),
                  ],
                );
              },
            ),

            Gap(20),
            AppButton(
              text: AppTexts.signUp,
              onPressed: _handleSignUp,
              width: double.infinity,
              height: 50,
              backgroundColor: AppColors.kPrimary500,
              textColor: AppColors.kWhiteColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              isLoading: isSignUpLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBirthdayPicker extends StatelessWidget {
  const _AppBirthdayPicker({required TextEditingController birthdateController}) : _birthdateController = birthdateController;

  final TextEditingController _birthdateController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(AppTexts.birthdateLabel, fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.kDark3),
        Gap(10),
        TextFormField(
          controller: _birthdateController,
          readOnly: true,
          decoration: InputDecoration(
            labelText: AppTexts.birthdateLabel,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.kPrimary500, width: 2),
            ),
          ),
          onTap: () async {
            final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
            if (picked != null) {
              _birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
            }
          },
          validator: (value) => ValidatorsUtil.validateBirthdate(value),
        ),
        // DateTimeFormField(
        //   firstDate: DateTime(1900),
        //   lastDate: DateTime.now(),
        //   decoration: InputDecoration(
        //     labelText: AppTexts.birthdateLabel,
        //     // hintText: AppTexts.birthdateHint,
        //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        //     focusedBorder: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(10),
        //       borderSide: BorderSide(color: AppColors.kPrimary500, width: 2),
        //     ),
        //   ),
        //   mode: DateTimeFieldPickerMode.date,
        //   onChanged: (date) => _birthdateController.text = date != null ? DateFormat('dd/MM/yyyy').format(date) : '',
        //   padding: EdgeInsets.zero,
        //   validator: (value) => ValidatorsUtil.validateBirthdate(value?.toIso8601String().split('T').first),
        // ),
      ],
    );
  }
}

class ButtonApple extends ConsumerWidget {
  const ButtonApple({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final isLoading = ref.watch(signInLoadingProvider);

    return AppButton(
      text: AppTexts.appleSignInButton,
      onPressed: () => ref.read(signUpWithAppleProvider(context)),
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
      onPressed: () => ref.read(signUpWithGoogleProvider(context)),
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
