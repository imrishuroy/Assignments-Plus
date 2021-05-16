import 'dart:async';

import 'package:flutter_todo/models/todo.dart';

abstract class BaseTodosRepository {
  Future<void> addNewTodo(Todo todo);

  Future<void> deleteTodo(Todo todo);
  Stream<List<Todo>> todos();

  Future<void> updateTodo(Todo todo);
}
