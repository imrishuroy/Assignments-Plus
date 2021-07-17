part of 'publictodo_bloc.dart';

class PublictodoState extends Equatable {
  const PublictodoState();

  @override
  List<Object> get props => [];
}

class PublictodoLoading extends PublictodoState {}

class PublicTodosLoaded extends PublictodoState {
  final List<PublicTodo> todos;
  PublicTodosLoaded({required this.todos});

  @override
  List<Object> get props => [todos];
  @override
  bool? get stringify => true;
}

class PublicTodosNotLoaded extends PublictodoState {}
