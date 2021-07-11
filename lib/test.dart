import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/models/app_user_model.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _auth = context.read<AuthRepository>();

    return Scaffold(
      body: StreamBuilder<AppUser?>(
          stream: _auth.onAuthChanges,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final appUser = snapshot.data;
            return Center(
              child: Text('${appUser?.uid}'),
            );
          }),
    );
  }
}
