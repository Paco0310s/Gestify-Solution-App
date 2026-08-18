import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gestify_solution/common/constants/app_assets.dart';
import 'package:gestify_solution/common/features/splash/splash_provider.dart';
import 'package:gestify_solution/common/widgets/app_loading_widget.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashStartupLogicProvider(context));
    });

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity, height: 200, child: Image.asset(AppAssets.logo)),
          const SizedBox(height: 16),
          const AppLoadingWidget(),
        ],
      ),
    );
  }
}
