import 'package:flutter/material.dart';
import 'package:flutter_todo/models/app_tab_bar.dart';
import 'package:flutter_todo/screens/profile/profile_screen.dart';
import 'package:flutter_todo/screens/public-todo/public_todos_screen.dart';
import 'package:flutter_todo/screens/todos/add_edit_todo_screen.dart';
import 'package:flutter_todo/widgets/filtered_todos.dart';
import 'package:flutter_todo/widgets/stats.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:universal_platform/universal_platform.dart';

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
    if (!UniversalPlatform.isWeb) {
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
      return FilteredTodos();
    } else if (widget.activeTab == AppTab.stats) {
      return Stats();
    } else if (widget.activeTab == AppTab.public) {
      return PublicTodosScreen();
    } else {
      return ProfileScreen();
    }
  }
}