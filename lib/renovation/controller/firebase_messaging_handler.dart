
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:exservice/renovation/controller/data_store.dart';
import 'dart:async';
import 'dart:developer';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

class FirebaseMessagingHandler {
  // AndroidNotificationChannel channel;

  static final instance = FirebaseMessagingHandler._internal();
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotificationSettings settings;

  FirebaseMessagingHandler._internal();

  Future<void> requestPermissions() async {
    settings = await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  Future<void> initialize() async {
    await Firebase.initializeApp();

    const initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // if (!kIsWeb) {
    //   channel = const AndroidNotificationChannel(
    //     'high_importance_channel', // id
    //     'High Importance Notifications', // title
    //     'This channel is used for important notifications.', // description
    //     importance: Importance.high,
    //   );
    //
    //   await flutterLocalNotificationsPlugin
    //       .resolvePlatformSpecificImplementation<
    //           AndroidFlutterLocalNotificationsPlugin>()
    //       ?.createNotificationChannel(channel);
    //
    //   await FirebaseMessaging.instance
    //       .setForegroundNotificationPresentationOptions(
    //     alert: true,
    //     badge: true,
    //     sound: true,
    //   );
    // }
    log("Firebase initialized", name: "$runtimeType");
  }

  void setToken(String token) {
    log("FCM TOKEN $token", name: "$runtimeType");
    if (token != DataStore.instance.fcmToken && DataStore.instance.hasUser) {
      DataStore.instance.fcmToken = token;
      // GetIt.I.get<UserProvider>().updateToken(token);//todo upload token
    }
  }

  void tokenMonitor() {
    FirebaseMessaging.instance.getToken().then(setToken);
    FirebaseMessaging.instance.onTokenRefresh.listen(setToken);
    log("Token monitor initialized", name: "$runtimeType");
  }

  void messageMonitor() {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        log("on init : ${message.data}", name: "$runtimeType");
        log("on init : ${message.notification?.title}", name: "$runtimeType");
        //todo
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("on message : ${message.data}", name: "$runtimeType");
      log("on message : ${message.notification?.title}", name: "$runtimeType");
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        print(notification.hashCode);
        _flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              '100',
              'DLite',
              'DLite',
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
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("on open : ${message.data}", name: "$runtimeType");
      log("on open : ${message.notification?.title}", name: "$runtimeType");
      //todo
    });
    log("Message monitor initialized", name: "$runtimeType");
  }
}
