import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

int id = 0;

/// A notification action which triggers a url launch event
const String urlLaunchActionId = 'id_1';

/// A notification action which triggers a App navigation event
const String navigationActionId = 'id_3';

/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late AndroidNotificationChannel channel;

  Future<void> initialiseSettings(
      void Function(NotificationResponse)? onTapNotification) async {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.high,
    );

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
      DarwinNotificationCategory(
        darwinNotificationCategoryText,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.text(
            'text_1',
            'Action 1',
            buttonTitle: 'Send',
            placeholder: 'Placeholder',
          ),
        ],
      ),
      DarwinNotificationCategory(
        darwinNotificationCategoryPlain,
        actions: <DarwinNotificationAction>[
          DarwinNotificationAction.plain('id_1', 'Action 1'),
          DarwinNotificationAction.plain(
            'id_2',
            'Action 2 (destructive)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.destructive,
            },
          ),
          DarwinNotificationAction.plain(
            navigationActionId,
            'Action 3 (foreground)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.foreground,
            },
          ),
          DarwinNotificationAction.plain(
            'id_4',
            'Action 4 (auth required)',
            options: <DarwinNotificationActionOption>{
              DarwinNotificationActionOption.authenticationRequired,
            },
          ),
        ],
        options: <DarwinNotificationCategoryOption>{
          DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
        },
      )
    ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      onDidReceiveLocalNotification:
          (int id, String? title, String? body, String? payload) async {
        // didReceiveLocalNotificationStream.add(
        //   ReceivedNotification(
        //     id: id,
        //     title: title,
        //     body: body,
        //     payload: payload,
        //   ),
        // );
      },
      notificationCategories: darwinNotificationCategories,
    );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onTapNotification

        //     (response) {
        //   Logger.d('onDidReceiveNotificationResponse id', response.id);
        //   Logger.d('onDidReceiveNotificationResponse', response.payload);
        // }

        // onDidReceiveBackgroundNotificationResponse: (response) {
        //   Logger.d(
        //       'onDidReceiveBackgroundNotificationResponse', response.toString());
        // },
        // onDidReceiveNotificationResponse: onTapNotification,
        // onDidReceiveNotificationResponse: onTapNotification,
        );
  }

  Future<void> showNotification({
    required RemoteMessage message,
  }) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            playSound: true,
            icon: 'launch_background',
          ),
        ),
        payload: jsonEncode(message.data),
      );
    }
  }

  // Future<void> showNotificationMediaStyle({
  //   required RemoteMessage message,
  // }) async {
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   final imageUrl = message.data['imageUrl'] as String?;
  //   final String? largeIconPath = imageUrl != null
  //       ? await _downloadAndSaveFile(message.data['imageUrl'], 'largeIcon')
  //       : null;

  //   if (notification != null && android != null && !kIsWeb) {
  //     flutterLocalNotificationsPlugin.show(
  //       notification.hashCode,
  //       notification.title,
  //       notification.body,
  //       NotificationDetails(
  //         android: AndroidNotificationDetails(
  //           channel.id,
  //           channel.name,
  //           channelDescription: channel.description,
  //           playSound: true,
  //           icon: 'launch_background',
  //           largeIcon: largeIconPath != null
  //               ? FilePathAndroidBitmap(largeIconPath)
  //               : null,
  //         ),
  //       ),
  //       payload: jsonEncode(message.data),
  //     );
  //   }

  // final String largeIconPath =
  //     await _downloadAndSaveFile(mediaUrl, 'largeIcon');
  // final id = Random().nextInt(100);

  // final AndroidNotificationDetails androidPlatformChannelSpecifics =
  //     AndroidNotificationDetails(
  //   'media channel id',
  //   'media channel name',
  //   channelDescription: 'media channel description',
  //   largeIcon: FilePathAndroidBitmap(largeIconPath),
  //   styleInformation: const MediaStyleInformation(),
  // );
  // final NotificationDetails platformChannelSpecifics =
  //     NotificationDetails(android: androidPlatformChannelSpecifics);
  // await flutterLocalNotificationsPlugin.show(
  //   title,
  //   body,
  //   platformChannelSpecifics,
  //   payload: payload,
  // );
  //}

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
      title,
      message,
      tz.TZDateTime.from(time, tz.local),

      //  tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          // channelDescription,
          priority: Priority.high,
          importance: Importance.max,
        ),
        // iOS: const IOSNotificationDetails(
        //   subtitle: 'Reminder',
        // ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showBigPictureNotification() async {
    var bigPictureStyleInformation = const BigPictureStyleInformation(
      DrawableResourceAndroidBitmap('chat_icon'),
      largeIcon: DrawableResourceAndroidBitmap('chat_icon'),
      contentTitle: 'flutter devs',
      summaryText: 'summaryText',
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'big text channel id', 'big text channel name',
        //  'big text channel description',
        styleInformation: bigPictureStyleInformation);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: null);
    await flutterLocalNotificationsPlugin.show(
      0,
      'big text title',
      'silent body',
      platformChannelSpecifics,
      payload: 'big image notifications',
    );
  }

  // Future<String> _downloadAndSaveFile(String url, String fileName) async {
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   final String filePath = '${directory.path}/$fileName';
  //   final http.Response response = await http.get(Uri.parse(url));
  //   final File file = File(filePath);
  //   await file.writeAsBytes(response.bodyBytes);
  //   return filePath;
  // }

  // Future<void> cancelNotification(int id) async {
  //   await flutterLocalNotificationsPlugin.cancel(id);
  // }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}



// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// import '/all_imports.dart';

// int id = 0;

// /// A notification action which triggers a url launch event
// const String urlLaunchActionId = 'id_1';

// /// A notification action which triggers a App navigation event
// const String navigationActionId = 'id_3';

// /// Defines a iOS/MacOS notification category for text input actions.
// const String darwinNotificationCategoryText = 'textCategory';

// /// Defines a iOS/MacOS notification category for plain actions.
// const String darwinNotificationCategoryPlain = 'plainCategory';

// class LocalNotificationHelper {
//   String? selectedNotificationPayload;

//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initialiseSettings() async {
//     final NotificationAppLaunchDetails? notificationAppLaunchDetails =
//         !kIsWeb && Platform.isLinux
//             ? null
//             : await flutterLocalNotificationsPlugin
//                 .getNotificationAppLaunchDetails();
//     // String initialRoute = HomePage.routeName;
//     if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
//       selectedNotificationPayload =
//           notificationAppLaunchDetails!.notificationResponse?.payload;
//       // initialRoute = SecondPage.routeName;
//     }

//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('launch_background');

//     final List<DarwinNotificationCategory> darwinNotificationCategories =
//         <DarwinNotificationCategory>[
//       DarwinNotificationCategory(
//         darwinNotificationCategoryText,
//         actions: <DarwinNotificationAction>[
//           DarwinNotificationAction.text(
//             'text_1',
//             'Action 1',
//             buttonTitle: 'Send',
//             placeholder: 'Placeholder',
//           ),
//         ],
//       ),
//       DarwinNotificationCategory(
//         darwinNotificationCategoryPlain,
//         actions: <DarwinNotificationAction>[
//           DarwinNotificationAction.plain('id_1', 'Action 1'),
//           DarwinNotificationAction.plain(
//             'id_2',
//             'Action 2 (destructive)',
//             options: <DarwinNotificationActionOption>{
//               DarwinNotificationActionOption.destructive,
//             },
//           ),
//           DarwinNotificationAction.plain(
//             navigationActionId,
//             'Action 3 (foreground)',
//             options: <DarwinNotificationActionOption>{
//               DarwinNotificationActionOption.foreground,
//             },
//           ),
//           DarwinNotificationAction.plain(
//             'id_4',
//             'Action 4 (auth required)',
//             options: <DarwinNotificationActionOption>{
//               DarwinNotificationActionOption.authenticationRequired,
//             },
//           ),
//         ],
//         options: <DarwinNotificationCategoryOption>{
//           DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
//         },
//       )
//     ];

//     /// Note: permissions aren't requested here just to demonstrate that can be
//     /// done later
//     final DarwinInitializationSettings initializationSettingsDarwin =
//         DarwinInitializationSettings(
//       requestAlertPermission: false,
//       requestBadgePermission: false,
//       requestSoundPermission: false,
//       onDidReceiveLocalNotification:
//           (int id, String? title, String? body, String? payload) async {
//         // didReceiveLocalNotificationStream.add(
//         //   ReceivedNotification(
//         //     id: id,
//         //     title: title,
//         //     body: body,
//         //     payload: payload,
//         //   ),
//         // );
//       },
//       notificationCategories: darwinNotificationCategories,
//     );
//     final LinuxInitializationSettings initializationSettingsLinux =
//         LinuxInitializationSettings(
//       defaultActionName: 'Open notification',
//       defaultIcon: AssetsLinuxIcon('icons/app_icon.png'),
//     );
//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsDarwin,
//       macOS: initializationSettingsDarwin,
//       linux: initializationSettingsLinux,
//     );
//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse:
//           (NotificationResponse notificationResponse) {
//         switch (notificationResponse.notificationResponseType) {
//           case NotificationResponseType.selectedNotification:
//             // selectNotificationStream.add(notificationResponse.payload);
//             break;
//           case NotificationResponseType.selectedNotificationAction:
//             if (notificationResponse.actionId == navigationActionId) {
//               //  selectNotificationStream.add(notificationResponse.payload);
//             }
//             break;
//         }
//       },
//       onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
//     );
//   }

//   @pragma('vm:entry-point')
//   void notificationTapBackground(NotificationResponse notificationResponse) {
//     // ignore: avoid_print
//     print('notification(${notificationResponse.id}) action tapped: '
//         '${notificationResponse.actionId} with'
//         ' payload: ${notificationResponse.payload}');
//     if (notificationResponse.input?.isNotEmpty ?? false) {
//       // ignore: avoid_print
//       print(
//           'notification action tapped with input: ${notificationResponse.input}');
//     }
//   }

//   Future<bool> isAndroidPermissionGranted() async {
//     if (Platform.isAndroid) {
//       final bool granted = await flutterLocalNotificationsPlugin
//               .resolvePlatformSpecificImplementation<
//                   AndroidFlutterLocalNotificationsPlugin>()
//               ?.areNotificationsEnabled() ??
//           false;

//       return granted;
//     }
//     return false;
//   }

//   Future<bool> requestPermissions() async {
//     if (Platform.isIOS || Platform.isMacOS) {
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//             alert: true,
//             badge: true,
//             sound: true,
//             critical: true,
//           );
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               MacOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//             alert: true,
//             badge: true,
//             sound: true,
//             critical: true,
//           );
//     } else if (Platform.isAndroid) {
//       final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//           flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>();

//       final bool? granted = await androidImplementation?.requestPermission();

//       return granted ?? false;
//     }
//     return false;
//   }

//   void configureDidReceiveLocalNotificationSubject() {}

//   void configureSelectNotificationSubject() {}

//   Future<void> showNotification() async {
//     Logger.d('Runs', 'aa');
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );
//     const NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);
//     await flutterLocalNotificationsPlugin.show(
//         id++, 'plain title', 'plain body', notificationDetails,
//         payload: 'item x');
//   }

//   Future<void> showNotificationWithActions() async {
//     const AndroidNotificationDetails androidNotificationDetails =
//         AndroidNotificationDetails(
//       'your channel id',
//       'your channel name',
//       channelDescription: 'your channel description',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//       actions: <AndroidNotificationAction>[
//         AndroidNotificationAction(
//           urlLaunchActionId,
//           'Action 1',
//           icon: DrawableResourceAndroidBitmap('food'),
//           contextual: true,
//         ),
//         AndroidNotificationAction(
//           'id_2',
//           'Action 2',
//           titleColor: Color.fromARGB(255, 255, 0, 0),
//           icon: DrawableResourceAndroidBitmap('secondary_icon'),
//         ),
//         AndroidNotificationAction(
//           navigationActionId,
//           'Action 3',
//           icon: DrawableResourceAndroidBitmap('secondary_icon'),
//           showsUserInterface: true,
//           // By default, Android plugin will dismiss the notification when the
//           // user tapped on a action (this mimics the behavior on iOS).
//           cancelNotification: false,
//         ),
//       ],
//     );

//     const DarwinNotificationDetails iosNotificationDetails =
//         DarwinNotificationDetails(
//       categoryIdentifier: darwinNotificationCategoryPlain,
//     );

//     const DarwinNotificationDetails macOSNotificationDetails =
//         DarwinNotificationDetails(
//       categoryIdentifier: darwinNotificationCategoryPlain,
//     );

//     const LinuxNotificationDetails linuxNotificationDetails =
//         LinuxNotificationDetails(
//       actions: <LinuxNotificationAction>[
//         LinuxNotificationAction(
//           key: urlLaunchActionId,
//           label: 'Action 1',
//         ),
//         LinuxNotificationAction(
//           key: navigationActionId,
//           label: 'Action 2',
//         ),
//       ],
//     );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iosNotificationDetails,
//       macOS: macOSNotificationDetails,
//       linux: linuxNotificationDetails,
//     );
//     await flutterLocalNotificationsPlugin.show(
//       id++,
//       'plain title',
//       'plain body',
//       notificationDetails,
//       payload: 'item z',
//     );
//   }
// }


// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:universal_platform/universal_platform.dart';

// class NotificationService {
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   void initialiseSettings(
//       Future<void> Function(String? value) onPressed) async {
//     if (!UniversalPlatform.isWeb) {
//       // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
//       final AndroidInitializationSettings initializationSettingsAndroid =
//           AndroidInitializationSettings('app_icon');

//       final IOSInitializationSettings initializationSettingsIOS =
//           IOSInitializationSettings();

//       final MacOSInitializationSettings initializationSettingsMacOS =
//           MacOSInitializationSettings();

//       final InitializationSettings initializationSettings =
//           InitializationSettings(
//         android: initializationSettingsAndroid,
//         iOS: initializationSettingsIOS,
//         macOS: initializationSettingsMacOS,
//       );

//       await flutterLocalNotificationsPlugin.initialize(
//         initializationSettings,
//         onSelectNotification: onPressed,
//       );
//     }
//   }

//   Future<void> showNotification({
//     required String? title,
//     required String? body,
//     required String? payload,
//   }) async {
//     final id = Random().nextInt(100);
//     var android = new AndroidNotificationDetails(
//       'id',
//       'channel ',
//       //'description',
//       priority: Priority.high,
//       importance: Importance.max,
//     );
//     var iOS = new IOSNotificationDetails();
//     var platform = new NotificationDetails(android: android, iOS: iOS);
//     await flutterLocalNotificationsPlugin.show(
//       id,
//       '${title ?? 'Hello'}',
//       '${body ?? 'You may have new notifications'}',
//       platform,
//       payload: payload ?? '',
//     );
//   }

//   Future<void> sheduledNotification({
//     required DateTime time,
//     required String channelId,
//     required String channelName,
//     required String channelDescription,
//     required int id,
//     required String title,
//     required String message,
//   }) async {
//     flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       '$title',
//       '$message',
//       tz.TZDateTime.from(time, tz.local),

//       //  tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
//       NotificationDetails(
//         android: AndroidNotificationDetails(
//           '$channelId',
//           '$channelName',
//           //'$channelDescription',
//           priority: Priority.high,
//           importance: Importance.max,
//         ),
//         iOS: IOSNotificationDetails(
//           subtitle: 'Reminder',
//         ),
//       ),
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       androidAllowWhileIdle: true,
//     );
//   }

//   Future<void> showBigPictureNotification() async {
//     var bigPictureStyleInformation = BigPictureStyleInformation(
//       DrawableResourceAndroidBitmap("chat_icon"),
//       largeIcon: DrawableResourceAndroidBitmap("chat_icon"),
//       contentTitle: 'flutter devs',
//       summaryText: 'summaryText',
//     );
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//         'big text channel id', 'big text channel name',
//         //  'big text channel description',
//         styleInformation: bigPictureStyleInformation);
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics, iOS: null);
//     await flutterLocalNotificationsPlugin.show(
//       0,
//       'big text title',
//       'silent body',
//       platformChannelSpecifics,
//       payload: "big image notifications",
//     );
//   }

//   Future<void> showNotificationMediaStyle() async {
//     var androidPlatformChannelSpecifics = AndroidNotificationDetails(
//       'media channel id',
//       'media channel name',
//       //s 'media channel description',
//       color: Colors.red,
//       enableLights: true,
//       largeIcon: DrawableResourceAndroidBitmap("chat_icon"),
//       styleInformation: MediaStyleInformation(),
//     );
//     var platformChannelSpecifics = NotificationDetails(
//         android: androidPlatformChannelSpecifics, iOS: null);
//     await flutterLocalNotificationsPlugin.show(
//         0, 'notification title', 'notification body', platformChannelSpecifics);
//   }

//   Future<void> cancelNotification(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
// }
