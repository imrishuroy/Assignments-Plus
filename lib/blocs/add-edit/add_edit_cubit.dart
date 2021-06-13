import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';

import 'package:flutter_todo/models/failure_model.dart';
import 'package:flutter_todo/models/todo_model.dart';

import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'add_edit_state.dart';

class AddEditCubit extends Cubit<AddEditState> {
  final TodosBloc? _todosBloc;

  AddEditCubit({
    @required TodosBloc? todosBloc,
  })  : _todosBloc = todosBloc,
        super(AddEditState.initial());

  void titleChanged(String value) async {
    emit(state.copyWith(title: value, status: AddEditStatus.initial));
  }

  void todoChanged(String value) async {
    emit(state.copyWith(todo: value, status: AddEditStatus.initial));
  }

  // void notificationTimeChanged(DateTime dateTime) async{
  //   emit(state.copyWith())
  // }

  bool get canSubmit => state.todo != '';

  void addEditTodo({
    @required String? todo,
    @required title,
    @required DateTime? dateTime,
    DateTime? notificationDate,
    int? notificationId,
  }) async {
    if (state.status == AddEditStatus.submitting) return;
    emit(state.copyWith(status: AddEditStatus.submitting));
    try {
      print('THis runs---------------');
      print(notificationDate);
      print(notificationId);
      _todosBloc?.add(
        AddTodo(
          Todo(
            title: title!,
            todo: todo!,
            id: Uuid().v4(),
            //dateTime: DateTime.now(),
            dateTime: dateTime!,
            notificationDate: notificationDate,
            notificationId: notificationId,
            // notificationDate: null,
            // notificationId: null,
          ),
        ),
      );
      emit(state.copyWith(status: AddEditStatus.succuss));
    } catch (error) {
      print('Error -----------${error.toString()}');
      emit(
        state.copyWith(
          status: AddEditStatus.failure,
          failure: Failure(
            message: error.toString(),
          ),
        ),
      );
    }
  }
}
