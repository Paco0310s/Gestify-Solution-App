import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gestify_solution/common/constants/app_assets.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/models/files/adapted_file.dart';
import 'package:gestify_solution/common/widgets/app_image.dart';
import 'package:gestify_solution/common/widgets/app_text.dart';

class AppHeaderAuth extends StatelessWidget {
  const AppHeaderAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppImage(AdaptedFile.asset(AppAssets.logo), height: 50, width: 50),
        Gap(10),
        AppText(AppTexts.appName, fontSize: 25, fontWeight: FontWeight.bold, color: AppColors.kPrimary500),
        Spacer(),
        DropdownButton2<Locale>(
          underline: const SizedBox.shrink(),
          isDense: true,
          isExpanded: true,
          customButton: Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.kNeutral300),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.flag, size: 20, color: Colors.black54),
                SizedBox(width: 4),
                Text(AppTexts.languageEnglish, style: TextStyle(fontSize: 14, color: AppColors.kDark3)),
                SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, size: 20, color: Colors.black54),
              ],
            ),
          ),
          items: [
            DropdownItem(value: Locale('en', 'US'), child: Text(AppTexts.languageEnglish)),
            DropdownItem(value: Locale('es', 'ES'), child: Text(AppTexts.languageSpanish)),
          ],
          onChanged: (value) {
            // Handle language change
          },
          dropdownStyleData: DropdownStyleData(
            width: 200,
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
          // value: Locale('en', 'US'),
          iconStyleData: IconStyleData(icon: Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.black54)),
        ),
        SizedBox(width: 5),
        // Button to toggle dark mode (for demonstration)
        IconButton(
          icon: Icon(Icons.brightness_5_outlined, size: 20, color: Colors.black54),
          onPressed: () {
            // Handle dark mode toggle
          },
        ),
      ],
    );
  }
}
