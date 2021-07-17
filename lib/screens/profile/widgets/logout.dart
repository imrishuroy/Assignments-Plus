import 'package:assignments/blocs/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

  Future<void> _signOutUser(BuildContext context) async {
    try {
      var result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('SignOut'),
            content: Text('Do you want to signOut ?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          );
        },
      );

      final bool logout = await result ?? false;
      if (logout) {
        BlocProvider.of<AuthBloc>(context)..add(AuthLogoutRequested());
      }
    } catch (error) {
      print(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () async {
        await _signOutUser(context);
      },
      icon: Icon(
        Icons.logout,
        color: Colors.red,
      ),
      label: Text(
        'Logout',
        style: TextStyle(color: Colors.red),
      ),
    );
  }
}
