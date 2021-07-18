import 'package:assignments/config/auth_wrapper.dart';
import 'package:assignments/screens/contact/contact_us_screen.dart';
import 'package:assignments/screens/home/home_screen.dart';
import 'package:assignments/screens/login/login_screen.dart';
import 'package:assignments/screens/privacy/privacy_policy.dart';
import 'package:assignments/screens/public-todo/add_edit_public_todos.dart';
import 'package:assignments/screens/todos/add_edit_todo_screen.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            settings: const RouteSettings(name: '/'),
            builder: (_) => Scaffold());

      case AuthWrapper.routeName:
        return AuthWrapper.route();

      case LoginScreen.routeName:
        return LoginScreen.route();

      case HomeScreen.routeName:
        return HomeScreen.route(settings.arguments as String);

      case AddEditTodoScreen.routeName:
        return AddEditTodoScreen.route(settings.arguments);

      case AddEditPublicTodoScreen.routeName:
        return AddEditPublicTodoScreen.route();

      case PrivicyPolicy.routeName:
        return PrivicyPolicy.route();

      case ContactUsScreen.routeName:
        return ContactUsScreen.route();
      default:
        return _errorRoute();
    }
  }

  // static Route onGenerateNestedRouter(RouteSettings settings) {
  //   print('NestedRoute: ${settings.name}');
  //   switch (settings.name) {
  //     case ProfileScreen.routeName:
  //       return ProfileScreen.route();
  //     // args: settings.arguments as ProfileScreenArgs);
  //     case GalleryScreen.routeName:
  //       return GalleryScreen.route();
  //     case DashBoard.routeName:
  //       return DashBoard.route();
  //     default:
  //       return _errorRoute();
  //   }
  // }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text(
            'Error',
          ),
        ),
        body: const Center(
          child: Text(
            'Something went wrong',
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
