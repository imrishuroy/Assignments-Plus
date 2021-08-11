import 'package:assignments/config/paths.dart';
import 'package:assignments/models/failure_model.dart';
import 'package:assignments/models/todo_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'base_todo_repository.dart';

class TodosRepository implements BaseTodosRepository {
  final CollectionReference _usersRef =
      FirebaseFirestore.instance.collection(Paths.users);

  @override
  Future<void> addNewTodo(Todo todo, String userId) async {
    try {
      await _usersRef
          .doc(userId)
          .collection(Paths.todos)
          .withConverter<Todo>(
              fromFirestore: (snapshot, _) => Todo.fromMap(snapshot.data()!),
              toFirestore: (todo, _) => todo.toMap())
          .doc(todo.id)
          .set(todo);
    } catch (error) {
      print('Error updaing todos ${error.toString()}');
      throw Failure(message: 'Error updating todo !');
    }
  }

  @override
  Future<void> deleteTodo(Todo todo, String userId) async {
    try {
      await _usersRef
          .doc(userId)
          .collection(Paths.todos)
          .withConverter<Todo>(
              fromFirestore: (snapshot, _) => Todo.fromMap(snapshot.data()!),
              toFirestore: (todo, _) => todo.toMap())
          .doc(todo.id)
          .delete();
    } catch (error) {
      print('Delete todo error ${error.toString()}');
      throw Failure(message: 'Error deleting todo !');
    }
  }

  @override
  Stream<List<Todo>> todos(String userId) {
    return _usersRef
        .doc(userId)
        .collection(Paths.todos)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snaps) {
      return snaps.docs.map((doc) => Todo.fromMap(doc.data())).toList();
    });
  }

  @override
  Future<void> updateTodo(Todo todo, String userId) async {
    try {
      await _usersRef
          .doc(userId)
          .collection(Paths.todos)
          .withConverter<Todo>(
              fromFirestore: (snapshot, _) => Todo.fromMap(snapshot.data()!),
              toFirestore: (todo, _) => todo.toMap())
          .doc(todo.id)
          .update(todo.toMap());
    } catch (error) {
      print(error.toString());
      throw Failure(message: 'Error updating todos !');
    }
  }

  @required
  Stream<List<Todo>> searchTodos(String keyword, String? userId) {
    try {
      return _usersRef
          .doc(userId)
          .collection(Paths.todos)
          .where('title', isGreaterThanOrEqualTo: keyword)
          .withConverter<Todo>(
              fromFirestore: (snapshot, _) => Todo.fromMap(snapshot.data()!),
              toFirestore: (todo, _) => todo.toMap())
          .snapshots()
          .map((snaps) {
        return snaps.docs.map((doc) => doc.data()).toList();
      });
    } catch (error) {
      throw Failure(message: 'Error searching todos !');
    }
  }
}
