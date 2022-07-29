import 'dart:async';

import 'package:assignments/blocs/todo/todo_bloc.dart';
import 'package:assignments/models/todo_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'stats_event.dart';
part 'stats_state.dart';

class StatsBloc extends Bloc<StatsEvent, StatsState> {
  StreamSubscription? _todosSubscription;

  StatsBloc({TodosBloc? todosBloc})
      : assert(todosBloc != null),
        super(StatsInitial()) {
    _todosSubscription = todosBloc!.stream.listen((state) {
      if (state is TodosLoaded) {
        add(UpdateStats(state.todos));
      }
    });
    on<UpdateStats>((event, emit) {
      int numActive =
          event.todos.where((todo) => !todo.completed).toList().length;
      int numCompleted =
          event.todos.where((todo) => todo.completed).toList().length;

      emit(StatsLoaded(numActive, numCompleted));
    });
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}
