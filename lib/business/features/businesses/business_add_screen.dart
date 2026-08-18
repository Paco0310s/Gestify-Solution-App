import 'package:flutter/material.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/widgets/app_dashboard_layout.dart';
import 'package:gestify_solution/common/widgets/app_text_field.dart';

class BusinessAddScreen extends StatelessWidget {
  final String title;
  const BusinessAddScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppDashboardLayout(
      title: title,
      mobileChild: Center(child: Text(AppTexts.mobileView)),
      tabletChild: Center(child: Text(AppTexts.tabletView)),
      desktopChild: Center(child: AddBusinessDesktopView()),
    );
  }
}

class AddBusinessDesktopView extends StatelessWidget {
  const AddBusinessDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(padding: EdgeInsets.all(20), color: Colors.grey[200], child: AddBusinessForm()),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: EdgeInsets.all(20),
            child: Center(child: Text(AppTexts.previewArea)),
          ),
        ),
      ],
    );
  }
}

class AddBusinessForm extends StatelessWidget {
  const AddBusinessForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(text: AppTexts.businessNameLabel),
        SizedBox(height: 10),
        AppTextField(text: AppTexts.businessDescriptionLabel),
        SizedBox(height: 10),
        AppTextField(text: AppTexts.businessRfcLabel),
        SizedBox(height: 10),
        Text(AppTexts.businessLogoLabel),
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.kPrimary500),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(AppTexts.chooseFile),
        ),
        SizedBox(height: 20),
        ElevatedButton(onPressed: () {}, child: Text(AppTexts.save)),
      ],
    );
  }
}
