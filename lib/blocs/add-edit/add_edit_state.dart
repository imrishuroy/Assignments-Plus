part of 'add_edit_cubit.dart';

enum AddEditStatus { initial, submitting, succuss, failure }
enum ImageStatus { initial, submitting, succus, failure }

class AddEditState extends Equatable {
  final AddEditStatus? status;
  final String? todo;
  final String? imageUrl;
  final Failure? failure;

  AddEditState({
    @required this.status,
    @required this.todo,
    @required this.imageUrl,
    @required this.failure,
  });

  factory AddEditState.initial() {
    return AddEditState(
      status: AddEditStatus.initial,
      todo: '',
      imageUrl: '',
      failure: Failure(),
    );
  }

  @override
  List<Object?> get props => [status, todo, imageUrl, failure];

  AddEditState copyWith({
    AddEditStatus? status,
    String? todo,
    String? imageUrl,
    Failure? failure,
  }) {
    return AddEditState(
      status: status ?? this.status,
      todo: todo ?? this.todo,
      imageUrl: imageUrl ?? this.imageUrl,
      failure: failure ?? this.failure,
    );
  }
}
