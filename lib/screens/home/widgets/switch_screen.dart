import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:universal_platform/universal_platform.dart';

import '/models/app_tab_bar.dart';
import '/screens/activities/activities_screen.dart';
import '/screens/profile/profile_screen.dart';
import '/screens/public-todo/public_todos_tab.dart';
import '/screens/todos/add_edit_todo_screen.dart';
import '/widgets/filtered_todos.dart';

class SwitchScreens extends StatefulWidget {
  final AppTab activeTab;
  final String? sharedString;
  final String? title;
  final String? userId;

  const SwitchScreens(
      this.activeTab, this.sharedString, this.title, this.userId);

  @override
  _SwitchScreensState createState() => _SwitchScreensState();
}

class _SwitchScreensState extends State<SwitchScreens> {
  int count = 0;
  @override
  void dispose() {
    print('Switch screen dispose callled');
    if (!UniversalPlatform.isWeb) {
      ReceiveSharingIntent.reset();
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
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          Navigator.of(context).pushNamed(
            AddEditTodoScreen.routeName,
            arguments: {
              'sharedString': widget.sharedString,
              'title': widget.title
            },
          );
        },
      );
    }

    if (widget.activeTab == AppTab.todos) {
      return FilteredTodos(
        userId: widget.userId,
      );
    } else if (widget.activeTab == AppTab.stats) {
      // return Stats(
      //   userId: widget.userId,
      // );
      return ActivitiesScreen();
    } else if (widget.activeTab == AppTab.public) {
      return PublicTodosTab();
    } else {
      return ProfileScreen();
    }
  }
}
