import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/models/app_tab_bar.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';
import 'package:flutter_todo/screens/home/change_theme.dart';
import 'package:flutter_todo/widgets/extra_actions.dart';
import 'package:flutter_todo/widgets/filter_button.dart';

AppBar mainAppBar(AppTab activeTab, BuildContext context) {
  return AppBar(
    automaticallyImplyLeading: false,
    title: Text('Your Todos'),
    actions: [
      FilterButton(visible: activeTab == AppTab.todos),
      ExtraActions(),
      SizedBox(
        width: 5,
      ),
      TextButton(
        onPressed: () {
          RepositoryProvider.of<AuthRepository>(context).signOut();
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
  );
}
