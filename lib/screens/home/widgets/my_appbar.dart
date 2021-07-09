import 'package:flutter/material.dart';
import 'package:flutter_todo/models/app_tab_bar.dart';
import 'package:flutter_todo/screens/home/change_theme.dart';
import 'package:flutter_todo/widgets/extra_actions.dart';
import 'package:flutter_todo/widgets/filter_button.dart';

class MyAppBar extends StatelessWidget {
  final AppTab? activeTab;

  const MyAppBar({Key? key, this.activeTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (activeTab == AppTab.todos) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Your Todos'),
        actions: [
          FilterButton(visible: activeTab == AppTab.todos),
          ExtraActions(),
          const SizedBox(width: 5),
        ],
      );
    } else if (activeTab == AppTab.profile) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: Text('Your Profile'),
        actions: [
          ChangeTheme(),
          const SizedBox(width: 10.0),
        ],
      );
    } else if (activeTab == AppTab.stats) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Track your progress'),
      );
    } else if (activeTab == AppTab.public) {
      return AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Public Todos'),
      );
    }
    return AppBar();
  }
}
