import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';
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
  ) async* {}
}
