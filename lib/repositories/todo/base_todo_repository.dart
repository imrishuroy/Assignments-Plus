import 'dart:async';

import 'package:assignments/models/todo_model.dart';

abstract class BaseTodosRepository {
  Future<void> addNewTodo(Todo todo, String userId);

  Future<void> deleteTodo(Todo todo, String userId);
  Stream<List<Todo>> todos(String userId);

  Future<void> updateTodo(Todo todo, String userId);

  Stream<List<Todo>> searchTodos(String keyword, String userId);
}
