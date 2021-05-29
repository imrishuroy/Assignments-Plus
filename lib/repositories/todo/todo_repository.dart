import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/repositories/auth/auth_repository.dart';

import 'base_todo_repository.dart';

class TodosRepository implements BaseTodosRepository {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  AuthRepository auth = AuthRepository();

  @override
  Future<void> addNewTodo(Todo todo) async {
    // String id = Uuid().v4();

    return await usersRef
        .doc(uid)
        .collection('todos')
        .doc(todo.id)
        .set(todo.toMap());
  }

  @override
  Future<void> deleteTodo(Todo todo) {
    return usersRef.doc(uid).collection('todos').doc(todo.id).delete();
  }

  @override
  Stream<List<Todo>> todos() {
    return usersRef.doc(uid).collection('todos').snapshots().map((snaps) {
      return snaps.docs.map((doc) => Todo.fromMap(doc.data())).toList();
    });
  }

  @override
  Future<void> updateTodo(Todo todo) {
    return usersRef
        .doc(uid)
        .collection('todos')
        .doc(todo.id)
        .update(todo.toMap());
  }
}
