part of 'add_edit_cubit.dart';

enum AddEditStatus { initial, submitting, succuss, failure }

class AddEditState extends Equatable {
  final AddEditStatus? status;
  final String? title;
  final String? todo;
  // final DateTime? notificationDate;
  final Failure? failure;

  AddEditState({
    @required this.status,
    @required this.title,
    @required this.todo,
    @required this.failure,

    /// @required this.notificationDate,
  });

  factory AddEditState.initial() {
    return AddEditState(
      status: AddEditStatus.initial,
      todo: '',
      title: '',
      failure: Failure(),
      // notificationDate: DateTime.now(),
    );
  }

  AddEditState copyWith({
    AddEditStatus? status,
    String? title,
    String? todo,
    DateTime? notificationDate,
    Failure? failure,
  }) {
    return AddEditState(
      status: status ?? this.status,
      title: title ?? this.title,
      todo: todo ?? this.todo,
      //  notificationDate: notificationDate ?? this.notificationDate,
      failure: failure ?? this.failure,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      status,
      title,
      todo,
      // notificationDate,
      failure,
    ];
  }
}
