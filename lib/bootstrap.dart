import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:sheftaya/app/app.dart';
import 'package:sheftaya/core/di/service_locator.dart';
import 'package:sheftaya/features/notification/logic/update_fcm_cubit/update_fcm_cubit.dart';
import 'package:sheftaya/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

final Logger appLogger = Logger();

Future<void> bootstrap() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: 'assets/.env');

      setupServiceLocator();
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );
      setupServiceLocator();
      await _requestNotificationPermission();

      await ScreenUtil.ensureScreenSize();

      runApp(const Sheftaya());
    },
    (error, stack) {
      appLogger.e('Uncaught zone error', error: error, stackTrace: stack);
    },
  );
}

Future<void> _requestNotificationPermission() async {
  final settings = await FirebaseMessaging.instance.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false,
  );

  appLogger.i('🔔 Notification permission: ${settings.authorizationStatus}');

  if (settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional) {
    final updateFcmCubit = getIt<UpdateFcmCubit>();
    await updateFcmCubit.initializeAndSendToken();
  } else {
    appLogger.w('⚠️ Notification permission denied');
  }
}
