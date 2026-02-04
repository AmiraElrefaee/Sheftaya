import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:sheftaya/app/app.dart';
import 'package:sheftaya/core/di/service_locator.dart';

final Logger appLogger = Logger();

Future<void> bootstrap() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: 'assets/.env');

      setupServiceLocator();

      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );

      await ScreenUtil.ensureScreenSize();


      runApp(const Sheftaya());
    },
    (error, stack) {
      appLogger.e('Uncaught zone error', error: error, stackTrace: stack);
    },
  );
}
