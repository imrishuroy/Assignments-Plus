part of 'flitered_bloc.dart';

abstract class FilteredTodosState extends Equatable {
  const FilteredTodosState();

  @override
  List<Object> get props => [];
}

class FilteredTodosLoading extends FilteredTodosState {}

class FilteredTodosLoaded extends FilteredTodosState {
  final List<Todo> filteredTodos;
  final VisibilityFilter activeFilter;

  const FilteredTodosLoaded(
    this.filteredTodos,
    this.activeFilter,
  );

  @override
  List<Object> get props => [filteredTodos, activeFilter];

  @override
  String toString() {
    return 'FilteredTodosLoaded { filteredTodos: $filteredTodos, activeFilter: $activeFilter }';
  }
}
