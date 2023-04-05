import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import 'package:thia/modules/splash/splash_screen.dart';
import 'package:thia/utils/common_stream_io.dart';
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
  // FirebaseMessaging.onBackgroundMessage(FirebaseNotificationService(context1: NavigationService.navigatorKey.currentContext).firebaseMessagingBackgroundHandler);

  // await FirebaseNotificationService.initializeService();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  final client = getClient();
  runApp(MyApp(client: client));
  await runZonedGuarded(() async {}, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.client}) : super(key: key);

  final StreamChatClient client;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      navigatorKey: NavigationService.navigatorKey,
      // themeMode: ThemeMode.dark,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        fontFamily: GoogleFonts.inter().fontFamily,
        progressIndicatorTheme: ProgressIndicatorThemeData(color: Platform.isAndroid ? AppColors.primaryColor : null),
      ),
      darkTheme: ThemeData(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        fontFamily: GoogleFonts.inter().fontFamily,
        progressIndicatorTheme: ProgressIndicatorThemeData(color: Platform.isAndroid ? AppColors.primaryColor : null),
        colorScheme: const ColorScheme.dark(background: AppColors.backgroundColor),

      ),
      onInit: () {
        NavigationService.buildContext = context;
        streamChatClient = client;
      },
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(
          context,
          StreamChat(
            client: client,
            child: widget,
            streamChatThemeData: StreamChatThemeData(
              channelListHeaderTheme: StreamChannelListHeaderThemeData(
                avatarTheme: StreamAvatarThemeData(
                  borderRadius: BorderRadius.circular(50),
                ),
                titleStyle: black18bold,
              ),
              textTheme: StreamTextTheme.light(
                title: black18bold,
                body: black12w500,
              ),
              channelPreviewTheme: StreamChannelPreviewThemeData(
                subtitleStyle: black12w500,
                titleStyle: black18bold,
                unreadCounterColor: Colors.greenAccent,
                lastMessageAtStyle: grey12w500,
                avatarTheme: StreamAvatarThemeData(
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              channelHeaderTheme: StreamChannelHeaderThemeData(
                titleStyle: black18bold,
                avatarTheme: StreamAvatarThemeData(
                  borderRadius: BorderRadius.circular(50),
                ),
                subtitleStyle: grey12w500,
              ),
              otherMessageTheme: StreamMessageThemeData(
                messageBackgroundColor: AppColors.white,
                messageTextStyle: black16w500,
              ),
              ownMessageTheme: StreamMessageThemeData(
                messageBackgroundColor: AppColors.primaryColor,
                messageTextStyle: white16w500,
              ),
            ),
          ),
        ),
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

      home: const SplashScreen(),
    );
  }
}

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static BuildContext? buildContext;
}
