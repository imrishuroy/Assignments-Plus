import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;

import 'package:universal_platform/universal_platform.dart';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initialiseSettings(
      Future<void> Function(String? value) onPressed) async {
    if (!UniversalPlatform.isWeb) {
      // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
      final AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('app_icon');

      final IOSInitializationSettings initializationSettingsIOS =
          IOSInitializationSettings();

      final MacOSInitializationSettings initializationSettingsMacOS =
          MacOSInitializationSettings();

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS,
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: onPressed,
      );
    }
  }

  Future<void> showNotification({
    required String? title,
    required String? body,
    required String? payload,
  }) async {
    final id = Random().nextInt(100);
    var android = new AndroidNotificationDetails(
      'id',
      'channel ',
      'description',
      priority: Priority.high,
      importance: Importance.max,
    );
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android: android, iOS: iOS);
    await flutterLocalNotificationsPlugin.show(
      id,
      '${title ?? 'Hello'}',
      '${body ?? 'You may have new notifications'}',
      platform,
      payload: payload ?? '',
    );
  }

  Future<void> sheduledNotification({
    required DateTime time,
    required String channelId,
    required String channelName,
    required String channelDescription,
    required int id,
    required String title,
    required String message,
  }) async {
    flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      '$title',
      '$message',
      tz.TZDateTime.from(time, tz.local),

      //  tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          '$channelId',
          '$channelName',
          '$channelDescription',
          priority: Priority.high,
          importance: Importance.max,
        ),
        iOS: IOSNotificationDetails(
          subtitle: 'Reminder',
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("chat_icon"),
      largeIcon: DrawableResourceAndroidBitmap("chat_icon"),
      contentTitle: 'flutter devs',
      summaryText: 'summaryText',
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id',
        'big text channel name',
        'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);
    await flutterLocalNotificationsPlugin.show(
      0,
      'big text title',
      'silent body',
      platformChannelSpecifics,
      payload: "big image notifications",
    );
  }

  Future<void> showNotificationMediaStyle() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'media channel id',
      'media channel name',
      'media channel description',
      color: Colors.red,
      enableLights: true,
      largeIcon: DrawableResourceAndroidBitmap("chat_icon"),
      styleInformation: MediaStyleInformation(),
    );
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);
    await flutterLocalNotificationsPlugin.show(
        0, 'notification title', 'notification body', platformChannelSpecifics);
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
