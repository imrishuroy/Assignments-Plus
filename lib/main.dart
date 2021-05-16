import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/auth/auth_bloc.dart';
import 'package:flutter_todo/blocs/simple_bloc_oberver.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/config/custom_router.dart';
import 'package:flutter_todo/repository/auth/auth_repository.dart';
import 'package:flutter_todo/config/auth_wrapper.dart';
import 'package:flutter_todo/repository/todo/firebase_todo_repository.dart';

import 'blocs/todo/todo_bloc.dart';
import 'blocs/todo/todo_bloc.dart';
import 'repository/todo/base_todo_repository.dart';
import 'repository/todo/base_todo_repository.dart';
import 'repository/todo/firebase_todo_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  EquatableConfig.stringify = kDebugMode;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<TodosRepository>(
          create: (_) => TodosRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<TodosBloc>(
            create: (context) => TodosBloc(
              todosRepository: context.read<TodosRepository>(),
            )..add(LoadTodos()),
          )

          // BlocProvider<TodosBloc>(
          //   create: (context) {
          //     return TodosBloc(
          //       todosRepository: TodosRepository(),
          //     )..add(LoadTodos());
          //   },
          // )
        ],
        child: MaterialApp(
          darkTheme: ThemeData(backgroundColor: Colors.black),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // scaffoldBackgroundColor: Colors.black,
          ),
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: AuthWrapper.routeName,
        ),
      ),
    );
  }
}
