import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_todo/blocs/todo/todo_bloc.dart';

import 'package:flutter_todo/models/failure_model.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/repositories/utils/util_repository.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

part 'add_edit_state.dart';

class AddEditCubit extends Cubit<AddEditState> {
  final UtilsRepository? _utils;
  final TodosBloc? _todosBloc;

  AddEditCubit({
    @required UtilsRepository? utils,
    @required TodosBloc? todosBloc,
  })  : _utils = utils,
        _todosBloc = todosBloc,
        super(AddEditState.initial());

  void todoChanged(String value) async {
    emit(state.copyWith(todo: value, status: AddEditStatus.initial));
  }

  void imagePicked(String imageUrl) async {
    emit(state.copyWith(imageUrl: imageUrl, status: AddEditStatus.initial));
  }

  bool get canSubmit => state.imageUrl != '' && state.todo != '';

  void pickImage() async {
    emit(state.copyWith(imageStatus: ImageStatus.submitting));
    final imageUrl = await _utils?.getImage();
    if (imageUrl != null) {
      print('IMageUrl ------------------------------------------- $imageUrl');
      emit(
          state.copyWith(imageUrl: imageUrl, imageStatus: ImageStatus.initial));

      print('${state.imageUrl} -----------------------------------');
      emit(state.copyWith(imageStatus: ImageStatus.succus));
      print('${state.imageUrl} -----------------------------------');
    } else {
      emit(
        state.copyWith(
          status: AddEditStatus.failure,
          failure: Failure(message: 'Error picking image, Try again!'),
        ),
      );
    }
  }

  void addEditTodo({@required String? todo, @required String? imageUrl}) async {
    if (state.status == AddEditStatus.submitting) return;
    emit(state.copyWith(status: AddEditStatus.submitting));
    try {
      _todosBloc?.add(
        AddTodo(
          Todo(
            todo: todo!,
            imageUrl: imageUrl!,
            id: Uuid().v4(),
            dateTime: DateTime.now(),
          ),
        ),
      );
      emit(state.copyWith(status: AddEditStatus.succuss));
    } catch (error) {
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
