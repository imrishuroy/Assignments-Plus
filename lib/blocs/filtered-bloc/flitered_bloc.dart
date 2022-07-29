import 'dart:async';

import 'package:assignments/blocs/todo/todo_bloc.dart';
import 'package:assignments/models/todo_model.dart';
import 'package:assignments/models/visibility_filter.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'flitered_event.dart';
part 'flitered_state.dart';

class FilteredTodosBloc extends Bloc<FilteredTodosEvent, FilteredTodosState> {
  final TodosBloc _todosBloc;
  late StreamSubscription _todosSubscription;

  FilteredTodosBloc({@required TodosBloc? todosBloc})
      : assert(todosBloc != null),
        _todosBloc = todosBloc!,
        super(todosBloc.state is TodosLoaded
            ? FilteredTodosLoaded(
                (todosBloc.state as TodosLoaded).todos,
                VisibilityFilter.all,
              )
            : FilteredTodosLoading()) {
    _todosSubscription = todosBloc.stream.listen((state) {
      if (state is TodosLoaded) {
        add(UpdateTodos((todosBloc.state as TodosLoaded).todos));
      }
    });

    on<UpdateFilter>((event, emit) {
      final currentState = _todosBloc.state;
      if (currentState is TodosLoaded) {
        emit(FilteredTodosLoaded(
          _mapTodosToFilteredTodos(currentState.todos, event.filter),
          event.filter,
        ));
      }
    });

    on<UpdateTodos>((event, emit) {
      final visibilityFilter = state is FilteredTodosLoaded
          ? (state as FilteredTodosLoaded).activeFilter
          : VisibilityFilter.all;

      emit(FilteredTodosLoaded(
        _mapTodosToFilteredTodos(
          (_todosBloc.state as TodosLoaded).todos,
          visibilityFilter,
        ),
        visibilityFilter,
      ));
    });
  }

  List<Todo> _mapTodosToFilteredTodos(
      List<Todo> todos, VisibilityFilter filter) {
    return todos.where((todo) {
      if (filter == VisibilityFilter.all) {
        return true;
      } else if (filter == VisibilityFilter.active) {
        return !todo.completed;
      } else {
        return todo.completed;
      }
    }).toList();
  }

  @override
  Future<void> close() {
    _todosSubscription.cancel();
    return super.close();
  }
}
