import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:flutter_todo/models/public_todos.dart';
import 'package:flutter_todo/repositories/public-todos/public_todos_repository.dart';

part 'publictodo_event.dart';
part 'publictodo_state.dart';

class PublictodoBloc extends Bloc<PublictodoEvent, PublictodoState> {
  final PublicTodosRepository? _publicTodosRepository;
  StreamSubscription? _todosSubscription;
  PublictodoBloc({required PublicTodosRepository? publicTodosRepository})
      : assert(publicTodosRepository != null),
        _publicTodosRepository = publicTodosRepository,
        super(PublictodoLoading());

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
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
    await _todosSubscription?.cancel();
    _todosSubscription = _publicTodosRepository!
        .allTodos()
        .listen((todos) => add(PublicTodosUpdated(todos)));
  }

  Stream<PublictodoState> _mapAddPublicTodoToState(AddPublicTodo event) async* {
    _publicTodosRepository?.addPublicTodo(event.todo);
  }

  Stream<PublictodoState> _mapDeletePublicTodoToState(
      DeletePublicTodo event) async* {
    _publicTodosRepository?.deleteTodo(event.todo);
  }

  Stream<PublictodoState> _mapUpdatePublicTodoToState(
      UpdatePublicTodo event) async* {
    _publicTodosRepository?.updatePublicTodo(event.todo);
  }

  Stream<PublictodoState> _mapPublicTodosUpdated(
      PublicTodosUpdated event) async* {
    yield PublicTodosLoaded(todos: event.todos);
  }
}
