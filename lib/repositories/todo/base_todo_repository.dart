import 'dart:async';

import 'package:flutter_todo/models/todo_model.dart';

abstract class BaseTodosRepository {
  Future<void> addNewTodo(Todo todo);

  Future<void> deleteTodo(Todo todo);
  Stream<List<Todo>> todos();

  Future<void> updateTodo(Todo todo);
}
