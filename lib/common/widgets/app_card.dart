import 'package:flutter/material.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;

  const AppCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.kWhiteColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [BoxShadow(color: AppColors.kPrimary500, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: child,
    );
  }
}
