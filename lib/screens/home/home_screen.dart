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
  @override
  void initState() {
    tz.initializeTimeZones();
    RepositoryProvider.of<NotificationService>(context)
        .initialiseSettings(onSelectNotification);

    super.initState();
  }

  Future<void> onSelectNotification(String? payload) async {
    print('Nofication Clicked');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<TabBloc, AppTab>(
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
            body: FutureBuilder<String?>(
                future: ReceiveSharingIntent.getInitialText(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  String? _sharedText = snapshot.data;
                  if (_sharedText != null) {
                    print(
                        'This is shared text from homescren -------------- $_sharedText');
                    WidgetsBinding.instance?.addPostFrameCallback(
                      (_) {
                        Navigator.of(context).pushNamed(AddEditScreen.routeName,
                            arguments: _sharedText);
                      },
                    );
                  }
                  return SwitchScreens(activeTab);
                }),
            floatingActionButton: activeTab == AppTab.todos
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, AddEditScreen.routeName);
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

  const SwitchScreens(this.activeTab);

  @override
  Widget build(BuildContext context) {
    if (activeTab == AppTab.todos) {
      return FilteredTodos();
    } else if (activeTab == AppTab.stats) {
      return Stats();
    } else {
      return ProfileScreen();
    }
  }
}
