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
    primaryColor: AppColors.kPrimary500,
    scaffoldBackgroundColor: AppColors.kNeutral100,
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
      backgroundColor: AppColors.kDark2,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.kDark3),
      titleTextStyle: GoogleFonts.poppins(color: AppColors.kDark3, fontSize: 20, fontWeight: FontWeight.w600),
    ),
    textTheme: TextTheme(
      bodyLarge: GoogleFonts.poppins(color: AppColors.kDark3, fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: GoogleFonts.poppins(color: AppColors.kDark3, fontSize: 14, fontWeight: FontWeight.normal),
      bodySmall: GoogleFonts.poppins(color: AppColors.kDark3, fontSize: 12, fontWeight: FontWeight.normal),
      titleLarge: GoogleFonts.poppins(color: AppColors.kDark3, fontSize: 18, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.poppins(color: AppColors.kDark3, fontSize: 16, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.poppins(color: AppColors.kDark3, fontSize: 14, fontWeight: FontWeight.w600),
    ),
  );
}
