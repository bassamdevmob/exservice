import 'dart:async';
import 'dart:developer';

import 'package:exservice/controller/data_store.dart';
import 'package:exservice/firebase_options.dart';
import 'package:exservice/resources/repository/user_repository.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class FirebaseHandler {
  static final instance = FirebaseHandler._internal();
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationSettings settings;

  FirebaseHandler._internal();

  Future<void> requestPermissions() async {
    settings = await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    final initializationSettingsIOS = IOSInitializationSettings();

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectNotification,
    );

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    log("Firebase initialized", name: "$runtimeType");
  }

  void setToken(String token) {
    log("FCM TOKEN $token", name: "$runtimeType");
    // if (token == DataStore.instance.fcmToken) return;
    log("UPDATING TO SERVER $token", name: "$runtimeType");
    GetIt.I.get<UserRepository>().updateToken(token);
  }

  void clearNotifications() {
    _flutterLocalNotificationsPlugin.cancelAll();
    log("Clear Notifications", name: "$runtimeType");
  }

  void tokenMonitor() {
    if (DataStore.instance.hasToken) {
      FirebaseMessaging.instance.getToken().then(setToken);
      FirebaseMessaging.instance.onTokenRefresh.listen(setToken);
      log("Token monitor initialized", name: "$runtimeType");
    }
  }

  void messageMonitor() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        log("on init : ${message.data}", name: "$runtimeType");
        // if (message.data["id"] != null) {
        // }
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("on message : ${message.data}", name: "$runtimeType");
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              "100",
              runtimeType.toString(),
              importance: Importance.max,
              priority: Priority.high,
              onlyAlertOnce: true,
            ),
            iOS: IOSNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data["id"],
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      log("on open : ${message.data}", name: "$runtimeType");
      // if (message.data["id"] != null) {
      // }
    });
    log("Message monitor initialized", name: "$runtimeType");
  }

  Future<dynamic> _onSelectNotification(payload) async {}
}
