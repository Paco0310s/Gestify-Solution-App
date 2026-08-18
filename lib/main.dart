import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/constants/app_theme.dart';
import 'package:gestify_solution/common/logging/app_logger.dart';
import 'package:gestify_solution/common/routes/app_routes.dart';
import 'package:gestify_solution/common/routes/routes.dart';
import 'package:gestify_solution/common/services/storage_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize storage service
  await StorageService.init();

  // Initialize Logger
  AppLogger.initialize();
  AppLogger.info("🚀 Gestify Solution App Starting...");

  runApp(ProviderScope(child: GestifySolutionApp()));
}

class GestifySolutionApp extends ConsumerStatefulWidget {
  const GestifySolutionApp({super.key});

  @override
  ConsumerState<GestifySolutionApp> createState() => _GestifySolutionAppState();
}

class _GestifySolutionAppState extends ConsumerState<GestifySolutionApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  // ignore: unnecessary_overrides
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MaterialApp(
        localizationsDelegates: const [GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
        supportedLocales: const [Locale('es')],
        title: AppTexts.appName,
        theme: AppTheme().appTheme,
        initialRoute: Routes.splash,
        routes: AppRoutes().routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
