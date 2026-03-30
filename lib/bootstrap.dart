import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:sheftaya/app/app.dart';
import 'package:sheftaya/core/di/service_locator.dart';

import 'core/helper/app_bloc_observer.dart';

final Logger appLogger = Logger();

Future<void> bootstrap() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      await dotenv.load(fileName: 'assets/.env');

      setupServiceLocator();
      // Bloc.observer = MyBlocObserver();
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
