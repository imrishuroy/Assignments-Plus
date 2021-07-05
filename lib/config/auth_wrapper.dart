import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/auth/auth_bloc.dart';
import 'package:flutter_todo/screens/home/home_screen.dart';
import 'package:flutter_todo/screens/login/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  static const String routeName = '/authwrapper';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => AuthWrapper(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushNamed(LoginScreen.routeName);
        } else if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushNamed(HomeScreen.routeName);

          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (_) => GetSharedText(),
          //   ),
          // );
        }
      },
      child: Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
