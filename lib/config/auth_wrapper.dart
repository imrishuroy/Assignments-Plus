import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/auth/auth_bloc.dart';
import 'package:flutter_todo/screens/home/home_screen.dart';
import 'package:flutter_todo/screens/login/login_screen.dart';
import 'package:flutter_todo/screens/profile/profile_screen.dart';
import 'package:flutter_todo/widgets/filtered_todos.dart';

class AuthWrapper extends StatelessWidget {
  static const String routeName = '/auth';

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
          print(
              'State of user after authentication ----------${state.user?.uid}');
          //   Navigator.of(context).pushNamed(FilteredTodos.routeName);
          // Navigator.of(context)
          //     .pushNamed(ProfileScreen.routeName, arguments: state.user?.uid);
          Navigator.of(context)
              .pushNamed(HomeScreen.routeName, arguments: state.user?.uid);
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
