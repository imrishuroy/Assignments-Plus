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
  }

  @override
  Future<void> close() {
    _todosSubscription.cancel();
    return super.close();
  }

  @override
  Stream<PublictodoState> mapEventToState(
    PublictodoEvent event,
  ) async* {
    if (event is LoadPublicTodos) {
      yield* _mapLoadPublicTodos();
    } else if (event is AddPublicTodo) {
      yield* _mapAddPublicTodoToState(event);
    } else if (event is UpdatePublicTodo) {
      yield* _mapUpdatePublicTodoToState(event);
    } else if (event is DeletePublicTodo) {
      yield* _mapDeletePublicTodoToState(event);
    } else if (event is PublicTodosUpdated) {
      yield* _mapPublicTodosUpdated(event);
    }
  }

  Stream<PublictodoState> _mapLoadPublicTodos() async* {
    await _todosSubscription.cancel();
    _todosSubscription = _publicTodosRepository!
        .allTodos()
        .listen((todos) => add(PublicTodosUpdated(todos)));
  }

  Stream<PublictodoState> _mapAddPublicTodoToState(AddPublicTodo event) async* {
    _publicTodosRepository?.addPublicTodo(event.todo);
  }

  Stream<PublictodoState> _mapDeletePublicTodoToState(
      DeletePublicTodo event) async* {
    _publicTodosRepository?.deleteTodo(event.todo, userId);
  }

  Stream<PublictodoState> _mapUpdatePublicTodoToState(
      UpdatePublicTodo event) async* {
    _publicTodosRepository?.updatePublicTodo(event.todo, userId);
  }

  Stream<PublictodoState> _mapPublicTodosUpdated(
      PublicTodosUpdated event) async* {
    yield PublicTodosLoaded(todos: event.todos);
  }
}
