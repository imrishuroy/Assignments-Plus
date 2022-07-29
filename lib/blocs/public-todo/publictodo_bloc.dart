import 'dart:async';

import 'package:assignments/models/public_todos.dart';
import 'package:assignments/repositories/auth/auth_repository.dart';
import 'package:assignments/repositories/public-todos/public_todos_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'publictodo_event.dart';
part 'publictodo_state.dart';

class PublictodoBloc extends Bloc<PublictodoEvent, PublictodoState> {
  final PublicTodosRepository? _publicTodosRepository;
  late StreamSubscription _todosSubscription;

  final AuthRepository? _authRepository;
  String? userId;

  PublictodoBloc(
      {required PublicTodosRepository? publicTodosRepository,
      required AuthRepository? authRepository})
      : assert(publicTodosRepository != null),
        _authRepository = authRepository,
        _publicTodosRepository = publicTodosRepository,
        super(PublictodoLoading()) {
    _authRepository?.onAuthChanges.listen((user) {
      if (user?.uid != null) {
        userId = user?.uid;
        print('Public todo current user ${user?.uid}');

        _todosSubscription = _publicTodosRepository!.allTodos().listen((todos) {
          add(PublicTodosUpdated(todos));
        });
      }
    });

    on<LoadPublicTodos>((event, emit) async {
      await _todosSubscription.cancel();
      _todosSubscription = _publicTodosRepository!
          .allTodos()
          .listen((todos) => add(PublicTodosUpdated(todos)));
    });

    on<AddPublicTodo>((event, emit) async {
      await _publicTodosRepository?.addPublicTodo(event.todo);
    });

    on<UpdatePublicTodo>((event, emit) async {
      _publicTodosRepository?.updatePublicTodo(event.todo, userId);
    });

    on<DeletePublicTodo>((event, emit) async {
      _publicTodosRepository?.deleteTodo(event.todo, userId);
    });

    on<PublicTodosUpdated>((event, emit) {
      emit(PublicTodosLoaded(todos: event.todos));
    });
  }

  @override
  Future<void> close() {
    _todosSubscription.cancel();
    return super.close();
  }
}
