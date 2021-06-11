import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/tab/tab_bloc.dart';

import 'package:flutter_todo/models/app_tab_bar.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';
import 'package:flutter_todo/screens/home/change_theme.dart';
import 'package:flutter_todo/screens/profile/profile_screen.dart';

import 'package:flutter_todo/widgets/extra_actions.dart';
import 'package:flutter_todo/widgets/filter_button.dart';
import 'package:flutter_todo/widgets/filtered_todos.dart';
import 'package:flutter_todo/widgets/stats.dart';
import 'package:flutter_todo/widgets/tab_selector.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => HomeScreen(),
    );
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
                    title: Text('Your Todos'),
                    actions: [
                      FilterButton(visible: activeTab == AppTab.todos),
                      ExtraActions(),
                      SizedBox(width: 5),
                    ],
                  ),
            body: SwitchScreens(activeTab),
            floatingActionButton: activeTab == AppTab.todos
                ? FloatingActionButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/addTodo');
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
  Future<bool> askForLogout() async {
    return await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Hello there !'),
            content: Text('Do you want to logout...?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.red, fontSize: 17.0),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.green, fontSize: 17.0),
                ),
              )
            ],
          );
        });
  }

  _logout() async {
    if (await askForLogout()) {
      RepositoryProvider.of<AuthRepository>(context).signOut();
    }
  }

  return AppBar(
    automaticallyImplyLeading: false,
    title: Text('Your Profile'),
    actions: [
      TextButton(
        onPressed: _logout,
        child: Text(
          'Logout',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
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
