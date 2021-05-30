part of 'add_edit_cubit.dart';

enum AddEditStatus { initial, submitting, succuss, failure }
enum ImageStatus { initial, submitting, succus, failure }

class AddEditState extends Equatable {
  final AddEditStatus? status;
  final String? todo;
  final String? imageUrl;
  final Failure? failure;
  final ImageStatus? imageStatus;

  AddEditState({
    @required this.status,
    @required this.todo,
    @required this.imageUrl,
    @required this.failure,
    @required this.imageStatus,
  });

  factory AddEditState.initial() {
    return AddEditState(
      status: AddEditStatus.initial,
      todo: '',
      imageUrl: '',
      failure: Failure(),
      imageStatus: ImageStatus.initial,
    );
  }

  @override
  List<Object?> get props => [status, todo, imageUrl, failure, imageStatus];

  AddEditState copyWith({
    AddEditStatus? status,
    String? todo,
    String? imageUrl,
    Failure? failure,
    ImageStatus? imageStatus,
  }) {
    return AddEditState(
      status: status ?? this.status,
      todo: todo ?? this.todo,
      imageUrl: imageUrl ?? this.imageUrl,
      failure: failure ?? this.failure,
      imageStatus: imageStatus ?? this.imageStatus,
    );
  }
}
