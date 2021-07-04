import 'dart:async';

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
import 'package:http/http.dart' as http;

import 'package:html/parser.dart' show parse;

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
  late StreamSubscription? _stringSubscription;
  String? _sharedText;

  bool _loading = false;

  @override
  void initState() {
    _getSharedText();
    tz.initializeTimeZones();
    RepositoryProvider.of<NotificationService>(context)
        .initialiseSettings(onSelectNotification);

    super.initState();
  }

  Future<void> _getSharedText() async {
    setState(() {
      _loading = true;
    });
    try {
      // For sharing or opening urls/text coming from outside the app while the app is in the memory
      _intentDataStreamSubscription =
          ReceiveSharingIntent.getTextStream().listen((String? value) {
        print('------------------Function 1 (getTextStream) runs');
        // _sharedText = value;
        setState(() {
          _sharedText = value;
        });
      }, onError: (err) {
        print("getLinkStream error: $err");
      });
      // For sharing or opening urls/text coming from outside the app while the app is closed
      ReceiveSharingIntent.getInitialText().then((String? value) {
        print('------------------Function 2 (getInitialText) runs');
        //  _sharedText = value;
        setState(() {
          _sharedText = value;

          if (_sharedText != null) {
            //  print('Split------------${_sharedText.split('/')}');
            print('this runs 1');
            _getTitle(_sharedText!);

            //_getHeader(_sharedText);
          }

          // print('THis is my test $_sharedText');
          // if (_sharedText != null) {
          //   _getHeader(_sharedText!).then((value) {
          //     print('This is value $value ');
          //     if (value != null) {
          //       setState(() {
          //         _header = value;
          //         print('I am header 2 $_header');
          //       });
          //     }
          //   });
          // }
        });
      });

      setState(() {
        _loading = false;
      });
      print('Shared Text $_sharedText and Header is $_title');
    } catch (e) {
      setState(() {
        _loading = false;
      });
      print(e.toString());
    }
  }

  _getTitle(String sharedText) async {
    if (sharedText.contains('http') || sharedText.contains('https')) {
      print('this runs 2');
      var data = await MetadataFetch.extract(
          'https://www.freecodecamp.org/news/how-to-create-a-great-technical-course/');
      print('------------This is title ${data?.title}');
      setState(() {
        _title = data?.title;
      });
    }
  }

  String? _title;

  Future<void> onSelectNotification(String? payload) async {
    print('Nofication Clicked');
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    ReceiveSharingIntent?.reset();
    super.dispose();
  }

  String? header;

  @override
  Widget build(BuildContext context) {
    print('header ------------ ${_title.runtimeType}');
    print('header ------------ $_title');

    print(
        'This is the getted value --------------$_title and ------ $_sharedText ');
    return WillPopScope(
      onWillPop: () async => false,
      child: _loading
          ? Center(
              child: CircularProgressIndicator(),
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
                  body: SwitchScreens(activeTab, _sharedText, _title),

                  // FutureBuilder<String?>(
                  //     future: ReceiveSharingIntent.getInitialText(),
                  //     builder: (context, snapshot) {
                  //       if (snapshot.connectionState == ConnectionState.waiting) {
                  //         return Center(
                  //           child: CircularProgressIndicator(),
                  //         );
                  //       }
                  //       String? _sharedText = snapshot.data;
                  //       if (_sharedText != null) {
                  //         if (_sharedText.contains('http') ||
                  //             _sharedText.contains('https')) {
                  //           // final response = await http.get(url);

                  //           final String? headText = _getHeader(_sharedText);
                  //         }

                  //         print(
                  //             'This is shared text from homescren -------------- $_sharedText');
                  //         WidgetsBinding.instance?.addPostFrameCallback(
                  //           (_) {
                  //             Navigator.of(context).pushNamed(
                  //               AddEditScreen.routeName,
                  //               arguments: _sharedText,
                  //             );
                  //           },
                  //         );
                  //       }
                  // return SwitchScreens(activeTab);
                  //  }),
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

class SwitchScreens extends StatelessWidget {
  final AppTab activeTab;
  final String? sharedString;
  final String? title;

  const SwitchScreens(this.activeTab, this.sharedString, this.title);

  @override
  Widget build(BuildContext context) {
    if (sharedString != null) {
      WidgetsBinding.instance?.addPostFrameCallback(
        (_) {
          Navigator.of(context).pushNamed(
            AddEditScreen.routeName,
            arguments: {'sharedString': sharedString, 'title': title},
          );
        },
      );
    }

    if (activeTab == AppTab.todos) {
      return FilteredTodos();
    } else if (activeTab == AppTab.stats) {
      return Stats();
    } else {
      return ProfileScreen();
    }
  }
}
