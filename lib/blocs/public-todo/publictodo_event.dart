part of 'publictodo_bloc.dart';

abstract class PublictodoEvent extends Equatable {
  const PublictodoEvent();

  @override
  List<Object> get props => [];
}

class LoadPublicTodos extends PublictodoEvent {}

class AddPublicTodo extends PublictodoEvent {
  final PublicTodo todo;

  AddPublicTodo(this.todo);

  @override
  List<Object> get props => [todo];
  @override
  bool? get stringify => true;
}

class DeletePublicTodo extends PublictodoEvent {
  final PublicTodo todo;

  DeletePublicTodo(this.todo);
  @override
  List<Object> get props => [todo];
  @override
  bool? get stringify => true;
}

class UpdatePublicTodo extends TodosEvent {
  final PublicTodo todo;

  UpdatePublicTodo(this.todo);
  @override
  List<Object> get props => [todo];

  @override
  bool? get stringify => true;
}

class PublicTodosUpdated extends TodosEvent {
  final List<PublicTodo> todos;

  PublicTodosUpdated(this.todos);

  @override
  List<Object> get props => [props];

  @override
  bool? get stringify => true;
}
