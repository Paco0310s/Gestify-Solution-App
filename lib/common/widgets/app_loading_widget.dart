import 'package:flutter/material.dart';
import 'package:gestify_solution/common/constants/app_colors.dart';

class AppLoadingWidget extends StatelessWidget {
  final Color color;
  const AppLoadingWidget({super.key, this.color = AppColors.kPrimary500});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: color));
  }
}
