import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/repository/todo/base_todo_repository.dart';
import 'package:flutter_todo/services/todo_entities.dart';

class FirebaseTodosRepository implements TodosRepository {
  final CollectionReference todosRef =
      FirebaseFirestore.instance.collection('todos');
  @override
  Future<void> addNewTodo(Todo todo) {
    return todosRef.add(todo.toEntity().toDocument());
  }

  @override
  Future<void> deleteTodo(Todo todo) {
    return todosRef.doc(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return todosRef.snapshots().map((snaps) {
      return snaps.docs
          .map((doc) => Todo.fromEntity(TodoEntity.fromSnapshot(doc)))
          .toList();
    });
  }

  @override
  Future<void> updateTodo(Todo todo) {
    return todosRef.doc(todo.id).update(todo.toEntity().toDocument());
  }
}
