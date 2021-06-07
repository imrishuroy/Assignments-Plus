import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/models/app_tab_bar.dart';

class TabSelector extends StatelessWidget {
  final AppTab? activeTab;
  final Function(AppTab)? onTabSelected;

  TabSelector({
    Key? key,
    @required this.activeTab,
    @required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(activeTab!),
      onTap: (index) => onTabSelected!(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(
            icon: _tabIcon(tab),

            // Icon(
            //   tab == AppTab.todos ? Icons.list : Icons.show_chart,
            // ),
            // label: tab == AppTab.stats ? 'Stats' : 'Todos',
            label: _label(tab));
      }).toList(),
    );
  }
}

Widget _tabIcon(AppTab tab) {
  if (tab == AppTab.todos) {
    return Icon(Icons.list);
  } else if (tab == AppTab.stats) {
    return Icon(Icons.show_chart);
  } else {
    return Icon(Icons.person);
  }
}

String _label(AppTab tab) {
  if (tab == AppTab.todos) {
    return 'Todos';
  } else if (tab == AppTab.stats) {
    return 'Stats';
  } else {
    return 'Profile';
  }
}
