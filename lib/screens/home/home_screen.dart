import 'dart:async';
import 'package:assignments/blocs/tab/tab_bloc.dart';
import 'package:assignments/models/app_tab_bar.dart';
import 'package:assignments/screens/home/widgets/my_appbar.dart';
import 'package:assignments/screens/home/widgets/switch_screen.dart';
import 'package:assignments/screens/todos/add_edit_todo_screen.dart';
import 'package:assignments/services/notification_services.dart';
import 'package:assignments/widgets/loading_indicator.dart';
import 'package:assignments/widgets/tab_selector.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:universal_platform/universal_platform.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  final String? userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  static Route route(String? userId) {
    return PageRouteBuilder(
      settings: RouteSettings(
        name: routeName,
      ),
      pageBuilder: (context, _, __) => HomeScreen(
        userId: userId,
      ),
    );
  }

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late StreamSubscription? _intentDataStreamSubscription;

  String? _sharedText;
  String? _sharedTitle;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    print('Homescreen init runs');
    _notificationSetup();

    if (!UniversalPlatform.isWeb) {
      _getSharedText();
      tz.initializeTimeZones();
      RepositoryProvider.of<NotificationService>(context)
          .initialiseSettings(onSelectNotification);

      // if (!UniversalPlatform.isWeb) {
      //   _notificationSetup();
      // }

      //  _triggerAppMessaging();
    }
  }
  // just testing in app messaging
  // _triggerAppMessaging() async {
  //   await FirebaseInAppMessaging.instance.triggerEvent('purchase');
  // }

  Future<void> _notificationSetup() async {
    try {
      // asking for permissions
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        print('User granted permission');

        //gives you the message on which user taps and it opened the app from terminated state

        //    await messaging.getAPNSToken();
        FirebaseMessaging.instance.getInitialMessage().then((message) {
          if (message != null) {
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     AuthWrapper.routeName, (route) => false);

            // if (message.data['route'] == 'public') {
            //   // BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.public));
            // }
          }
        });

        ///Forground ( When the app is running in the forground )
        FirebaseMessaging.onMessage.listen((message) {
          if (message.notification != null) {
            final notification = context.read<NotificationService>();
            notification.showNotification(
                title: message.notification?.title,
                body: message.notification?.body,
                payload: message.data['route']);
          }
        });

        ///When the app is in background but opened and user taps
        FirebaseMessaging.onMessageOpenedApp.listen((message) {
          if (message.data['route'] == 'public') {
            BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.public));
          }
        });
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> _getSharedText() async {
    setState(() {
      _loading = true;
    });
    try {
      // For sharing or opening urls/text coming from outside the app while the app is in the memory
      _intentDataStreamSubscription =
          ReceiveSharingIntent.getTextStream().listen((String? value) {
        setState(() {
          _sharedText = value;
        });
      }, onError: (err) {
        print("getLinkStream error: $err");
      });
      // For sharing or opening urls/text coming from outside the app while the app is closed
      ReceiveSharingIntent.getInitialText().then((String? value) {
        setState(() {
          _sharedText = value;
          if (_sharedText != null) {
            _getSharedTitle(_sharedText!);
          }
        });
      });

      setState(() {
        _loading = false;
      });

      print('Shared Text $_sharedText and Header is $_sharedTitle');
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print(e.toString());
    }
  }

  void _getSharedTitle(String sharedText) async {
    setState(() {
      _loading = true;
    });
    if (sharedText.contains('http') || sharedText.contains('https')) {
      var data = await MetadataFetch.extract(sharedText);
      setState(() {
        _sharedTitle = data?.title;
        _loading = false;
        data = null;
      });
    }
  }

  Future<void> onSelectNotification(String? payload) async {
    print('Nofication Clicked');
    print('Payload $payload');

    if (payload == 'public') {
      BlocProvider.of<TabBloc>(context).add(UpdateTab(AppTab.public));
    }
  }

  @override
  void dispose() {
    if (!UniversalPlatform.isWeb) {
      ReceiveSharingIntent?.reset();
    }
    _intentDataStreamSubscription?.cancel();

    super.dispose();
    _sharedText = '';
    _sharedTitle = '';
  }

  Future<bool?> _existApp(BuildContext context) async {
    try {
      var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('SignOut'),
            content: Text('Do you want to signOut ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        },
      );

      final bool logout = await result ?? false;
      if (logout) {
        closeApp();

        return true;
      }
      return false;
    } catch (error) {
      print(error.toString());
    }
  }

  void closeApp() {
    if (UniversalPlatform.isAndroid) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else if (UniversalPlatform.isIOS) {
      // MinimizeApp.minimizeApp();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // onWillPop: () async => false,
      onWillPop: () async {
        return await _existApp(context) ?? false;
      },
      child: _loading
          ? Container(
              color: Colors.white,
              child: const LoadingIndicator(),
            )
          : BlocBuilder<TabBloc, AppTab>(
              builder: (context, activeTab) {
                return Scaffold(
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.miniCenterFloat,
                  appBar: PreferredSize(
                    preferredSize: Size.fromHeight(60),
                    child: MyAppBar(
                      activeTab: activeTab,
                    ),
                  ),
                  body: SwitchScreens(
                      activeTab, _sharedText, _sharedTitle, widget.userId),
                  floatingActionButton: activeTab == AppTab.todos
                      ? FloatingActionButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AddEditTodoScreen.routeName);
                          },
                          child: const Icon(Icons.add),
                          tooltip: 'Add Todo',
                        )
                      : null,
                  bottomNavigationBar: TabSelector(
                    activeTab: activeTab,
                    onTabSelected: (tab) =>
                        BlocProvider.of<TabBloc>(context).add(UpdateTab(tab)),
                  ),
                );
              },
            ),
    );
  }
}

// 2021-07-17T08:25:32_84840

// gcloud firestore import gs://assignments_bucket_transfered/2021-07-17T08:25:32_84840 --async

