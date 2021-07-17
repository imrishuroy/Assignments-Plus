import 'package:assignments/blocs/theme/theme_bloc.dart';
import 'package:assignments/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ThemeOption { light, dark }

class ChangeTheme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return PopupMenuButton<ThemeOption>(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
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
              child: Row(
                children: [
                  Icon(
                    Icons.light_mode_rounded,
                    color: Colors.amber,
                  ),
                  SizedBox(width: 10.0),
                  Text('Light'),
                ],
              ),
              value: ThemeOption.light,
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  Icon(
                    Icons.dark_mode_sharp,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10.0),
                  Text('Dark'),
                ],
              ),
              value: ThemeOption.dark,
            )
          ],
        );
      },
    );
  }
}
