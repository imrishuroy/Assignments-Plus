import 'package:assignments/models/app_tab_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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
      elevation: 20.0,
      type: BottomNavigationBarType.shifting,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      currentIndex: AppTab.values.indexOf(activeTab!),
      onTap: (index) => onTabSelected!(AppTab.values[index]),
      items: AppTab.values.map((tab) {
        return BottomNavigationBarItem(icon: _tabIcon(tab), label: _label(tab));
      }).toList(),
    );
  }
}

Widget _tabIcon(AppTab tab) {
  if (tab == AppTab.todos) {
    return Icon(Icons.list);
  } else if (tab == AppTab.stats) {
    return Icon(Icons.show_chart);
  } else if (tab == AppTab.public) {
    return Icon(Icons.public);
  } else {
    return Icon(Icons.person);
  }
}

// Widget ticon(AppTab tab) {
//   switch (tab) {
//     case AppTab.todos:
//       return Icon(Icons.list);

//       break;
//     default:
//   }
// }

String _label(AppTab tab) {
  if (tab == AppTab.todos) {
    return 'Todos';
  } else if (tab == AppTab.stats) {
    return 'Stats';
  } else if (tab == AppTab.public) {
    return 'Public';
  } else {
    return 'Profile';
  }
}
