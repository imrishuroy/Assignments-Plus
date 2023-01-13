import 'package:assignments/firebase_options.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:universal_platform/universal_platform.dart';

import '/blocs/auth/auth_bloc.dart';
import '/blocs/filtered-bloc/flitered_bloc.dart';
import '/blocs/profile/profile_bloc.dart';
import '/blocs/public-todo/publictodo_bloc.dart';
import '/blocs/simple_bloc_oberver.dart';
import '/blocs/stats/stats_bloc.dart';
import '/blocs/tab/tab_bloc.dart';
import '/blocs/theme/theme_bloc.dart';
import '/blocs/todo/todo_bloc.dart';
import '/config/auth_wrapper.dart';
import '/config/custom_router.dart';
import '/config/shared_prefs.dart';
import '/repositories/activities/activities_repo.dart';
import '/repositories/auth/auth_repository.dart';
import '/repositories/profile/profile_repository.dart';
import '/repositories/public-todos/public_todos_repository.dart';
import '/repositories/services/firebase_service.dart';
import '/repositories/todo/todo_repository.dart';
import '/repositories/utils/util_repository.dart';
import '/screens/activities/bloc/activities_bloc.dart';
import '/services/notification_services.dart';
import '/theme/app_theme.dart';

///Receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  //await Firebase.initializeApp();
  // await FirebaseMessaging.instance.requestPermission();
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // if (!UniversalPlatform.isWeb) {
  //   FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  // }

  //Bloc.observer = SimpleBlocObserver();
  EquatableConfig.stringify = kDebugMode;
  await SharedPrefs().init();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  if (UniversalPlatform.isAndroid) {
    //InAppPurchaseAndroidPlatformAddition.enablePendingPurchases();
  }
  Bloc.observer = SimpleBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
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
        RepositoryProvider<ActivitiesRepository>(
          create: (_) => ActivitiesRepository(),
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
                authRepository: context.read<AuthRepository>(),
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
          ),
          BlocProvider<ActivitiesBloc>(
            create: (context) => ActivitiesBloc(
              activitiesRepository: context.read<ActivitiesRepository>(),
            ),
          )
        ],
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Assignments Plus',
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


// #Rishu2024