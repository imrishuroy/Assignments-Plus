import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'add_edit_state.dart';

class AddEditCubit extends Cubit<AddEditState> {
  AddEditCubit() : super(AddEditInitial());
}
