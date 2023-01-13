import 'package:assignments/models/app_tab_bar.dart';
import 'package:assignments/pdf_download.dart';
import 'package:assignments/screens/home/change_theme.dart';
import 'package:assignments/widgets/extra_actions.dart';
import 'package:assignments/widgets/filter_button.dart';
import 'package:flutter/material.dart';

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
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PdfDownloader(),
              ),
            ),
            icon: Icon(Icons.download),
          ),
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
        title: const Text('Activites'),
      );
    }
    // } else if (activeTab == AppTab.public) {
    //   return AppBar(
    //     backgroundColor: Colors.green,
    //     elevation: 0.0,
    //     centerTitle: true,
    //     automaticallyImplyLeading: false,
    //     title: Padding(
    //       padding: const EdgeInsets.only(
    //         top: 25.0,
    //       ),
    //       child: const Text('Public Todos'),
    //     ),
    //   );
    // }
    return SizedBox.shrink();
    //  return AppBar();
  }
}
