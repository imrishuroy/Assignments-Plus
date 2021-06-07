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
                ? _profileAppBar()
                : AppBar(
                    automaticallyImplyLeading: false,
                    title: Text('Your Todos'),
                    actions: [
                      // if (activeTab == AppTab.todos)
                      FilterButton(visible: activeTab == AppTab.todos),
                      // if (activeTab == AppTab.todos)
                      ExtraActions(),
                      SizedBox(
                        width: 5,
                      ),
                      TextButton(
                        onPressed: () {
                          RepositoryProvider.of<AuthRepository>(context)
                              .signOut();
                        },
                        child: Text(
                          'LogOut',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(width: 7),
                      ChangeTheme(),
                      SizedBox(width: 7),
                    ],
                  ),
            body: SwitchScreens(activeTab),

            // activeTab == AppTab.todos ? FilteredTodos() : Stats(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, '/addTodo');
              },
              child: Icon(Icons.add),
              tooltip: 'Add Todo',
            ),
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

AppBar _profileAppBar() {
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
