part of 'add_edit_cubit.dart';

enum AddEditStatus { initial, submitting, succuss, failure }
enum ImageStatus { initial, submitting, succus, failure }

class AddEditState extends Equatable {
  final AddEditStatus? status;
  final String? title;
  final String? todo;
  final String? imageUrl;
  final Failure? failure;
  final ImageStatus? imageStatus;

  AddEditState({
    @required this.status,
    @required this.title,
    @required this.todo,
    @required this.imageUrl,
    @required this.failure,
    @required this.imageStatus,
  });

  factory AddEditState.initial() {
    return AddEditState(
      status: AddEditStatus.initial,
      todo: '',
      title: '',
      imageUrl: '',
      failure: Failure(),
      imageStatus: ImageStatus.initial,
    );
  }

  @override
  List<Object?> get props =>
      [status, todo, imageUrl, failure, imageStatus, title];

  AddEditState copyWith({
    AddEditStatus? status,
    String? title,
    String? todo,
    String? imageUrl,
    Failure? failure,
    ImageStatus? imageStatus,
  }) {
    return AddEditState(
      status: status ?? this.status,
      title: title ?? this.title,
      todo: todo ?? this.todo,
      imageUrl: imageUrl ?? this.imageUrl,
      failure: failure ?? this.failure,
      imageStatus: imageStatus ?? this.imageStatus,
    );
  }
}
