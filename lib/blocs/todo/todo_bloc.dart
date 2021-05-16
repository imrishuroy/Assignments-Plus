import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/repository/todo/todo_repository.dart';
import 'package:meta/meta.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository _todosRepository;
  StreamSubscription? _todosSubscription;

  TodosBloc({@required TodosRepository? todosRepository})
      : assert(todosRepository != null),
        _todosRepository = todosRepository!,
        super(TodosLoading());

  @override
  Stream<TodosState> mapEventToState(TodosEvent event) async* {
    if (event is AddTodo) {
      yield* _mapAddTodoToState(event);
    } else if (event is LoadTodos) {
      yield* _mapLoadTodosToState();
    } else if (event is TodosUpdated) {
      yield* _mapTodosUpdateToState(event);
    } else if (event is DeleteTodo) {
      yield* _mapDeleteTodoToState(event);
    } else if (event is UpdateTodo) {
      yield* _mapUpdateTodoToState(event);
    }
  }

  Stream<TodosState> _mapLoadTodosToState() async* {
    // yield TodosLoading();
    _todosSubscription?.cancel();
    _todosSubscription =
        _todosRepository.todos().listen((todos) => add(TodosUpdated(todos)));
  }

  Stream<TodosState> _mapTodosUpdateToState(TodosUpdated event) async* {
    yield TodosLoaded(event.todos);
  }

  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
    _todosRepository.addNewTodo(event.todo);
  }

  Stream<TodosState> _mapDeleteTodoToState(DeleteTodo event) async* {
    _todosRepository.deleteTodo(event.todo);
  }

  Stream<TodosState> _mapUpdateTodoToState(UpdateTodo event) async* {
    _todosRepository.updateTodo(event.updatedTodo);
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}
