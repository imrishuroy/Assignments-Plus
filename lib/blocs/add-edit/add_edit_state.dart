part of 'add_edit_cubit.dart';

enum AddEditStatus { initial, submitting, succuss, failure }

class AddEditState extends Equatable {
  final AddEditStatus? status;
  final String? title;
  final String? todo;
  final Failure? failure;

  AddEditState({
    @required this.status,
    @required this.title,
    @required this.todo,
    @required this.failure,
  });

  factory AddEditState.initial() {
    return AddEditState(
      status: AddEditStatus.initial,
      todo: '',
      title: '',
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [status, todo, failure, title];

  AddEditState copyWith({
    AddEditStatus? status,
    String? title,
    String? todo,
    Failure? failure,
  }) {
    return AddEditState(
      status: status ?? this.status,
      title: title ?? this.title,
      todo: todo ?? this.todo,
      failure: failure ?? this.failure,
    );
  }
}
