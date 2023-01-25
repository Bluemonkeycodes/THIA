import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:thia/modules/splash/splash_screen.dart';
import 'package:thia/utils/firebase_messaging_service.dart';
import 'package:thia/utils/utils.dart';

final GetStorage getPreference = GetStorage();

Future pref() async {
  await GetStorage.init();
}

Future<void> main() async {
  await pref();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseNotificationService.initializeService();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
  await runZonedGuarded(() async {}, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      // darkTheme: ThemeData(backgroundColor: AppColors.backgroundColor, brightness: Brightness.dark, canvasColor: AppColors.backgroundColor),
      themeMode: ThemeMode.light,
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget!),
        maxWidth: 1200,
        minWidth: 420,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(420, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
          const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
          const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
        ],
        backgroundColor: AppColors.backgroundColor,
        background: Container(color: AppColors.backgroundColor),
      ),
      theme: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        fontFamily: GoogleFonts.abhayaLibre().fontFamily,
        progressIndicatorTheme: ProgressIndicatorThemeData(color: Platform.isAndroid ? AppColors.buttonColor : null),
      ),
      home: const SplashScreen(),
      // home: const HomeScreen(),
    );
  }
}
