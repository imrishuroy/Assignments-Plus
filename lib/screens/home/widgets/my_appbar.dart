import 'package:flutter/material.dart';

import '/models/app_tab_bar.dart';
import '/screens/home/change_theme.dart';
import '/screens/home/widgets/pdf_download_button.dart';
import '/widgets/extra_actions.dart';
import '/widgets/filter_button.dart';

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
          const SizedBox(width: 5),
          PdfDownloadButton(),
          const SizedBox(width: 5),
          ExtraActions(),
          const SizedBox(width: 5),
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
