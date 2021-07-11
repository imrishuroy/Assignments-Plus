import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';
import 'package:flutter_todo/repositories/todo/todo_repository.dart';

import 'package:meta/meta.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository _todosRepository;
  late StreamSubscription _todosSubscription;
  late StreamSubscription _authSubsrciption;
  final AuthRepository _authRepository;
  //final String _userId;
  String? userId;
  TodosBloc(
      {@required TodosRepository? todosRepository,
      required AuthRepository authRepository})
      : assert(todosRepository != null),
        _todosRepository = todosRepository!,
        _authRepository = authRepository,
        //  _userId = userId,
        super(TodosLoading()) {
    _authSubsrciption = _authRepository.onAuthChanges.listen((user) {
      userId = user!.uid;
      _todosSubscription = _todosRepository.todos(userId!).listen((todos) {
        add(TodosUpdated(todos));
      });
    });
    // _todosSubscription = _todosRepository.todos(_userId).listen((todos) {
    //   add(TodosUpdated(todos));
    // });
  }

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
    _todosSubscription.cancel();
    _todosSubscription = _todosRepository
        .todos(userId!)
        .listen((todos) => add(TodosUpdated(todos)));
  }

  Stream<TodosState> _mapTodosUpdateToState(TodosUpdated event) async* {
    yield TodosLoaded(event.todos);
  }

  Stream<TodosState> _mapAddTodoToState(AddTodo event) async* {
    _todosRepository.addNewTodo(event.todo, userId!);
  }

  Stream<TodosState> _mapDeleteTodoToState(DeleteTodo event) async* {
    _todosRepository.deleteTodo(event.todo, userId!);
  }

  Stream<TodosState> _mapUpdateTodoToState(UpdateTodo event) async* {
    _todosRepository.updateTodo(event.updatedTodo, userId!);
  }

  @override
  Future<void> close() async {
    await _todosSubscription.cancel();
    return super.close();
  }
}
