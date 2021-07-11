import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/tab/tab_bloc.dart';
import 'package:flutter_todo/models/app_tab_bar.dart';
import 'package:flutter_todo/screens/home/widgets/my_appbar.dart';
import 'package:flutter_todo/screens/home/widgets/switch_screen.dart';
import 'package:flutter_todo/services/notification_services.dart';
import 'package:flutter_todo/test.dart';
import 'package:flutter_todo/widgets/tab_selector.dart';
import 'package:metadata_fetch/metadata_fetch.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:universal_platform/universal_platform.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/home';
  final String userId;

  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  // static Route route(String userId) {
  //   print('This is route userId --------- $userId');
  //   return MaterialPageRoute(
  //     settings: RouteSettings(
  //       name: routeName,
  //     ),
  //     builder: (context) => BlocProvider<TodosBloc>(
  //       create: (context) => TodosBloc(
  //           todosRepository: context.read<TodosRepository>(), userId: userId),
  //       child: HomeScreen(
  //         userId: userId,
  //       ),
  //     ),
  //   );
  // }
  static Route route(String userId) {
    print('This is route userId --------- $userId');
    return MaterialPageRoute(
      settings: RouteSettings(
        name: routeName,
      ),
      builder: (context) => HomeScreen(
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
    if (!UniversalPlatform.isWeb) {
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
    // final userId = ModalRoute.of(context)!.settings.arguments as String?;
    // print('---------------------UserId ---- $userId');
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
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => Test(),
                              ),
                            );
                            // Navigator.pushNamed(
                            //     context, AddEditTodoScreen.routeName);
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
