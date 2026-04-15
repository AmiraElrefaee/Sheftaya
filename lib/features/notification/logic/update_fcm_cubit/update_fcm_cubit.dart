import 'dart:convert';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:sheftaya/core/constants/shared_pref_helper.dart';
import 'package:sheftaya/core/constants/shared_pref_keys.dart';
import 'package:sheftaya/core/networking/server_result.dart';
import 'package:sheftaya/features/notification/data/models/update_fcm/update_fcm_token_request_body.dart';
import '../../data/repos/update_fcm_repo.dart';
import 'update_fcm_state.dart';

class UpdateFcmCubit extends Cubit<UpdateFcmState> {
  UpdateFcmCubit(this._updateFcmRepo) : super(const UpdateFcmState.initial());

  final UpdateFcmRepo _updateFcmRepo;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? _deviceToken;

  static const String _userDataKey = 'user_data';

  Future<void> initializeAndSendToken() async {
    await _requestPermission();
    await _initializeLocalNotifications();
    await _getDeviceToken();

    if (_deviceToken == null || _deviceToken!.isEmpty) {
      log('❌ FCM token is null or empty');
      return;
    }

    await _updateFcmToken();
    _listenToNotifications();
  }

  Future<void> _requestPermission() async {
    final settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log('📬 Permission status: ${settings.authorizationStatus}');
  }

  Future<void> _getDeviceToken() async {
    try {
      _deviceToken = await FirebaseMessaging.instance.getToken();
      log('🔑 FCM Token: $_deviceToken');
    } catch (e) {
      log('❌ Error getting FCM token: $e');
    }
  }

  Future<void> _updateFcmToken() async {
    emit(const UpdateFcmState.updateFcmLoading());

    final authToken = await SharedPrefHelper.getSecuredString(
      SharedPrefKeys.userToken,
    );

    if (authToken.isEmpty) {
      emit(const UpdateFcmState.updateFcmError(error: 'User not logged in'));
      return;
    }

    final cleanToken = authToken.startsWith('Bearer ')
        ? authToken.substring(7).trim()
        : authToken.trim();

    final requestBody = UpdateFcmTokenRequestBody(fcmToken: _deviceToken!);

    final response = await _updateFcmRepo.updateFcm(requestBody, cleanToken);

    response.when(
      success: (data) async {
        log('✅ FCM token updated: ${data.message}');

        final userDataString = await SharedPrefHelper.getSecuredString(
          _userDataKey,
        );

        if (userDataString.isNotEmpty) {
          try {
            final Map<String, dynamic> userMap = Map<String, dynamic>.from(
              jsonDecode(userDataString),
            );

            final dynamic dataPart = userMap['data'];
            if (dataPart is Map<String, dynamic>) {
              dataPart['fcmToken'] = _deviceToken;
              userMap['data'] = dataPart;

              await SharedPrefHelper.setSecuredString(
                _userDataKey,
                jsonEncode(userMap),
              );

              log('💾 Local user_data updated with FCM token');
            } else {
              log('⚠️ user_data format is invalid');
            }
          } catch (e) {
            log('❌ Error updating local user_data: $e');
          }
        } else {
          log('⚠️ No local user_data found to update');
        }

        emit(UpdateFcmState.updateFcmSuccess(data));
      },
      failure: (error) {
        log('❌ Update failed: ${error.serverFailure.errmessage}');
        emit(
          UpdateFcmState.updateFcmError(error: error.serverFailure.errmessage),
        );
      },
    );
  }

  Future<void> _initializeLocalNotifications() async {
    const androidChannel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Important notifications',
      importance: Importance.high,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_notification'),
      iOS: DarwinInitializationSettings(),
    );

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        log('👆 Notification clicked: ${details.payload}');
      },
    );
  }

  void _listenToNotifications() {
    FirebaseMessaging.onMessage.listen(_showNotification);

    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });
  }

  Future<void> _showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification == null || android == null) return;

    const androidDetails = AndroidNotificationDetails(
      'high_importance_channel',
      'High Importance Notifications',
      channelDescription: 'Important notifications',
      importance: Importance.high,
      priority: Priority.high,
      icon: 'ic_notification',
    );

    const notificationDetails = NotificationDetails(android: androidDetails);

    await _localNotificationsPlugin.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: notificationDetails,
      payload: message.data.toString(),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {
    log('📦 Notification data: ${message.data}');
  }

  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    log('📨 Background message: ${message.data}');
  }
}
