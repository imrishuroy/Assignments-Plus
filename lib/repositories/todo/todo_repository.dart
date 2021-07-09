import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/config/paths.dart';
import 'package:flutter_todo/models/todo_model.dart';

import 'base_todo_repository.dart';

class TodosRepository implements BaseTodosRepository {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection(Paths.users);
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // AuthRepository auth = AuthRepository();

  @override
  Future<void> addNewTodo(Todo todo) async {
    return await usersRef
        .doc(uid)
        .collection(Paths.todos)
        .doc(todo.id)
        .set(todo.toMap());
  }

  @override
  Future<void> deleteTodo(Todo todo) {
    return usersRef.doc(uid).collection(Paths.todos).doc(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return usersRef
        .doc(uid)
        .collection(Paths.todos)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snaps) {
      return snaps.docs.map((doc) => Todo.fromMap(doc.data())).toList();
    });
  }

  @override
  Future<void> updateTodo(Todo todo) {
    return usersRef
        .doc(uid)
        .collection(Paths.todos)
        .doc(todo.id)
        .update(todo.toMap());
  }

  @required
  Stream<List<Todo>> searchTodos(String keyword) {
    try {
      return usersRef
          .doc(uid)
          .collection(Paths.todos)

          // .where('title', isGreaterThanOrEqualTo: keyword)
          .where('title', isGreaterThanOrEqualTo: keyword)
          .snapshots()
          .map((snaps) {
        return snaps.docs.map((doc) => Todo.fromMap(doc.data())).toList();
      });
    } catch (error) {
      throw error;
    }
  }
}
