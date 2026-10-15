import 'package:flutter/material.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class NoTransitionsBuilder extends PageTransitionsBuilder {
  const NoTransitionsBuilder();

  @override
  Widget buildTransitions<T>(PageRoute<T> route, BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}

class AppTheme {
  final ThemeData appTheme = ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.kPrimary600,
    scaffoldBackgroundColor: const Color(0xffF8FAFC),
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.kPrimary600,
      primary: AppColors.kPrimary600,
      secondary: AppColors.kPrimary400,
      surface: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.kNeutral200, width: 1),
      ),
    ),
    dividerTheme: const DividerThemeData(
      color: AppColors.kNeutral200,
      thickness: 1,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: NoTransitionsBuilder(),
        TargetPlatform.iOS: NoTransitionsBuilder(),
        TargetPlatform.windows: NoTransitionsBuilder(),
        TargetPlatform.macOS: NoTransitionsBuilder(),
        TargetPlatform.linux: NoTransitionsBuilder(),
      },
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.kDark1),
      titleTextStyle: GoogleFonts.poppins(color: AppColors.kDark1, fontSize: 18, fontWeight: FontWeight.w600),
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(color: AppColors.kDark1, fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: GoogleFonts.poppins(color: AppColors.kDark2, fontSize: 14, fontWeight: FontWeight.normal),
      bodySmall: GoogleFonts.poppins(color: AppColors.kNeutral600, fontSize: 12, fontWeight: FontWeight.normal),
      titleLarge: GoogleFonts.poppins(color: AppColors.kDark1, fontSize: 18, fontWeight: FontWeight.w700),
      titleMedium: GoogleFonts.poppins(color: AppColors.kDark1, fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.poppins(color: AppColors.kDark2, fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}
