import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/tab/tab_bloc.dart';

import 'package:flutter_todo/models/app_tab_bar.dart';

import 'package:flutter_todo/screens/add_edit_todo_screen.dart';
import 'package:flutter_todo/screens/home/change_theme.dart';

import 'package:flutter_todo/screens/profile/profile_screen.dart';
import 'package:flutter_todo/services/notification_services.dart';

import 'package:flutter_todo/widgets/extra_actions.dart';
import 'package:flutter_todo/widgets/filter_button.dart';
import 'package:flutter_todo/widgets/filtered_todos.dart';
import 'package:flutter_todo/widgets/stats.dart';
import 'package:flutter_todo/widgets/tab_selector.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:timezone/data/latest.dart' as tz;

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => HomeScreen(),
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
    if (Platform.isAndroid || Platform.isIOS) {
      _getSharedText();
      tz.initializeTimeZones();
      RepositoryProvider.of<NotificationService>(context)
          .initialiseSettings(onSelectNotification);
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

      // if (_sharedText != null) {
      //   WidgetsBinding.instance?.addPostFrameCallback(
      //     (_) {
      //       Navigator.of(context).pushNamed(
      //         AddEditScreen.routeName,
      //         arguments: {
      //           'sharedString': _sharedText,
      //           'title': _sharedTitle,
      //         },
      //       );
      //     },
      //   );
      // }
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
      print('------------This is title ${data?.title}');
      setState(() {
        _sharedTitle = data?.title;
        _loading = false;
        data = null;
      });
    }
  }

  Future<void> onSelectNotification(String? payload) async {
    print('Nofication Clicked');
  }

  @override
  void dispose() {
    print('HomeScreen Dispose Called');

    if (Platform.isAndroid || Platform.isIOS) {
      ReceiveSharingIntent?.reset();
    }
    _intentDataStreamSubscription?.cancel();

    super.dispose();
    _sharedText = '';
    _sharedTitle = '';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: _loading
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : BlocBuilder<TabBloc, AppTab>(
              builder: (context, activeTab) {
                return Scaffold(
                  appBar: activeTab == AppTab.profile
                      ? _profileAppBar(context)
                      : AppBar(
                          automaticallyImplyLeading: false,
                          title: activeTab == AppTab.todos
                              ? Text('Your Todos')
                              : Text('Your Todos Data'),
                          actions: [
                            FilterButton(visible: activeTab == AppTab.todos),
                            ExtraActions(),
                            SizedBox(width: 5),
                          ],
                        ),
                  body: SwitchScreens(activeTab, _sharedText, _sharedTitle),
                  floatingActionButton: activeTab == AppTab.todos
                      ? FloatingActionButton(
                          onPressed: () {
                            Navigator.pushNamed(
                                context, AddEditScreen.routeName);
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (_) => HtmlHeading()));
                          },
                          child: Icon(Icons.add),
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

AppBar _profileAppBar(BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text('Your Profile'),
    actions: [
      ChangeTheme(),
      SizedBox(width: 10.0),
    ],
  );
}

class SwitchScreens extends StatefulWidget {
  final AppTab activeTab;
  final String? sharedString;
  final String? title;

  const SwitchScreens(this.activeTab, this.sharedString, this.title);

  @override
  _SwitchScreensState createState() => _SwitchScreensState();
}

class _SwitchScreensState extends State<SwitchScreens> {
  int count = 0;
  @override
  void dispose() {
    print('Switch screen dispose callled');
    if (Platform.isAndroid || Platform.isIOS) {
      ReceiveSharingIntent?.reset();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    count++;
    print('Value of count ------------ $count');
    print('Shared tesxt from SwitchScreen ------- ${widget.sharedString}');
    if (widget.activeTab == AppTab.todos &&
        widget.sharedString != null &&
        count == 1) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) {
          Navigator.of(context).pushNamed(
            AddEditScreen.routeName,
            arguments: {
              'sharedString': widget.sharedString,
              'title': widget.title
            },
          );
        },
      );
    }

    if (widget.activeTab == AppTab.todos) {
      return FilteredTodos();
    } else if (widget.activeTab == AppTab.stats) {
      return Stats();
    } else {
      return ProfileScreen();
    }
  }
}
