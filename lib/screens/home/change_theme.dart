import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/theme/theme_bloc.dart';
import 'package:flutter_todo/theme/app_theme.dart';

enum ThemeOption { light, dark }

class ChangeTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return PopupMenuButton<ThemeOption>(
          icon: Icon(Icons.settings),
          onSelected: (action) {
            switch (action) {
              case ThemeOption.light:
                BlocProvider.of<ThemeBloc>(context).add(
                  ThemeChanged(
                    AppTheme.values[ThemeOption.light.index],
                  ),
                );
                break;
              case ThemeOption.dark:
                BlocProvider.of<ThemeBloc>(context).add(
                  ThemeChanged(
                    AppTheme.values[ThemeOption.dark.index],
                  ),
                );
                break;
            }
          },
          itemBuilder: (context) => <PopupMenuItem<ThemeOption>>[
            PopupMenuItem(
              child: Text('Light'),
              value: ThemeOption.light,
            ),
            PopupMenuItem(
              child: Text('Dark'),
              value: ThemeOption.dark,
            )
          ],
        );
      },
    );
  }
}
