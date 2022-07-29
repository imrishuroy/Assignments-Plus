import 'dart:async';

import 'package:assignments/models/app_user_model.dart';
import 'package:assignments/models/todo_model.dart';
import 'package:assignments/repositories/auth/auth_repository.dart';
import 'package:assignments/repositories/todo/todo_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'todo_event.dart';
part 'todo_state.dart';

class TodosBloc extends Bloc<TodosEvent, TodosState> {
  final TodosRepository _todosRepository;
  StreamSubscription? _todosSubscription;
  StreamSubscription? _authSubsrciption;
  final AuthRepository _authRepository;
  //final String _userId;
  String? userId;
  TodosBloc({
    @required TodosRepository? todosRepository,
    required AuthRepository authRepository,
  })  : assert(todosRepository != null),
        _todosRepository = todosRepository!,
        _authRepository = authRepository,
        //  _userId = userId,
        super(TodosLoading()) {
    _authSubsrciption = _authRepository.onAuthChanges.listen((AppUser? user) {
      //userId = user!.uid;
      if (user?.uid != null) {
        userId = user?.uid;
        _todosSubscription = _todosRepository.todos(userId!).listen((todos) {
          add(TodosUpdated(todos));
        });
      }
    });

    on<AddTodo>((event, emit) async {
      await _todosRepository.addNewTodo(event.todo, userId!);
    });

    on<LoadTodos>((event, emit) {
      _todosSubscription?.cancel();
      if (userId != null) {
        _todosSubscription = _todosRepository
            .todos(userId!)
            .listen((todos) => add(TodosUpdated(todos)));
      }
    });

    on<TodosUpdated>((event, emit) {
      emit(TodosLoaded(event.todos));
    });

    on<DeleteTodo>((event, emit) async {
      await _todosRepository.deleteTodo(event.todo, userId!);
    });

    on<UpdateTodo>((event, emit) async {
      await _todosRepository.updateTodo(event.updatedTodo, userId!);
    });
  }

  @override
  Future<void> close() async {
    await _todosSubscription?.cancel();
    await _authSubsrciption?.cancel();
    return super.close();
  }
}
