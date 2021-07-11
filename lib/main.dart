import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_todo/blocs/auth/auth_bloc.dart';
import 'package:flutter_todo/blocs/filtered-bloc/flitered_bloc.dart';
import 'package:flutter_todo/blocs/profile/profile_bloc.dart';
import 'package:flutter_todo/blocs/public-todo/publictodo_bloc.dart';
import 'package:flutter_todo/blocs/simple_bloc_oberver.dart';
import 'package:flutter_todo/blocs/stats/stats_bloc.dart';
import 'package:flutter_todo/blocs/tab/tab_bloc.dart';
import 'package:flutter_todo/blocs/theme/theme_bloc.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
import 'package:flutter_todo/config/custom_router.dart';
import 'package:flutter_todo/config/auth_wrapper.dart';
import 'package:flutter_todo/config/shared_prefs.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';
import 'package:flutter_todo/repositories/profile/profile_repository.dart';
import 'package:flutter_todo/repositories/public-todos/public_todos_repository.dart';
import 'package:flutter_todo/repositories/services/firebase_service.dart';
import 'package:flutter_todo/repositories/todo/todo_repository.dart';
import 'package:flutter_todo/repositories/utils/util_repository.dart';
import 'package:flutter_todo/services/notification_services.dart';
import 'package:flutter_todo/theme/app_theme.dart';
import 'blocs/todo/todo_bloc.dart';
import 'package:universal_platform/universal_platform.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = SimpleBlocObserver();
  EquatableConfig.stringify = kDebugMode;
  await SharedPrefs().init();
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
        ),
        RepositoryProvider<FirebaseServices>(
          create: (_) => FirebaseServices(),
        ),
        RepositoryProvider<UitilsRepository>(
          create: (_) => UitilsRepository(),
        ),
        RepositoryProvider<PublicTodosRepository>(
          create: (_) => PublicTodosRepository(),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (_) => ProfileRepository(),
        ),
        if (!UniversalPlatform.isWeb)
          RepositoryProvider<NotificationService>(
            create: (_) => NotificationService(),
          ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ThemeBloc>(
            create: (context) => ThemeBloc(),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<PublictodoBloc>(
            create: (context) => PublictodoBloc(
                publicTodosRepository: context.read<PublicTodosRepository>())
              ..add(LoadPublicTodos()),
          ),
          BlocProvider<TodosBloc>(
            create: (context) => TodosBloc(
              authRepository: context.read<AuthRepository>(),
              todosRepository: context.read<TodosRepository>(),
            )..add(LoadTodos()),
          ),
          BlocProvider<TabBloc>(
            create: (context) => TabBloc(),
          ),
          BlocProvider<FilteredTodosBloc>(
            create: (context) => FilteredTodosBloc(
              todosBloc: BlocProvider.of<TodosBloc>(context),
            ),
          ),
          BlocProvider<StatsBloc>(
            create: (context) =>
                StatsBloc(todosBloc: BlocProvider.of<TodosBloc>(context)),
          ),
          BlocProvider<ProfileBloc>(
            //lazy: false,
            create: (context) => ProfileBloc(
              profileRepository: context.read<ProfileRepository>(),
              authRepository: context.read<AuthRepository>(),
            )..add(LoadProfile()),
          )
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: '+Assignments',
              theme:
                  appThemeData[AppTheme.values.elementAt(SharedPrefs().theme)],
              onGenerateRoute: CustomRouter.onGenerateRoute,
              initialRoute: AuthWrapper.routeName,
            );
          },
        ),
      ),
    );
  }
}
