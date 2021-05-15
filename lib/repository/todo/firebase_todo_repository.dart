import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo/models/todo.dart';
import 'package:flutter_todo/models/todo_model.dart';
import 'package:flutter_todo/repository/todo/base_todo_repository.dart';
import 'package:flutter_todo/services/todo_entities.dart';
import 'package:uuid/uuid.dart';

import '../../models/app_user_model.dart';
import '../auth/auth_repository.dart';
import '../auth/auth_repository.dart';
import '../auth/auth_repository.dart';

class TodosRepository implements BaseTodosRepository {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  AuthRepository auth = AuthRepository();
  @override
  // Future<void> addNewTodo(Todo todo) async {
  Future<void> addNewTodo(Todo todo) async {
    // return todosRef.add(todo.toEntity().toDocument());
    AppUser? user = await auth.currentUser;
    print('TODO ID ${usersRef.id}');
    print('UID ${user?.uid}');

    String id = Uuid().v4();

    return await usersRef
        .doc(user?.uid)
        .collection('todos')
        .doc(id)
        .set(todo.toMap());
  }

  @override
  Future<void> deleteTodo(Todo todo) {
    return usersRef.doc(todo.id).delete();
  }

  // @override
  // Stream<List<Todo>> todos() {
  //   return todosRef.get();
  //   // return todosRef.snapshots().map((snaps) {

  //   //   // return snaps.docs
  //   //   //     .map((doc) => Todo.fromEntity(TodoEntity.fromSnapshot(doc)))
  //   //   //     .toList();
  //   // });
  // }

  @override
  Future<void> updateTodo(Todo todo) {
    //return todosRef.doc(todo.id).update(todo.toEntity().toDocument());
    return usersRef.get();
  }
}
