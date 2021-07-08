import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo/config/paths.dart';
import 'package:flutter_todo/models/failure_model.dart';
import 'package:flutter_todo/models/public_todos.dart';

class PublicTodosRepository {
  final CollectionReference publicTodos =
      FirebaseFirestore.instance.collection(Paths.public);

  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

//  Stream<List todos()  {
//     final usersRef = await publicTodos.get();
//     usersRef.docs.forEach((element) {
//       element.data();
//     });
//   }

  Stream<List<PublicTodo?>>? allTodos() {
    try {
      publicTodos.snapshots().map((snaps) {
        return snaps.docs.map((doc) => PublicTodo.fromMap(doc.data())).toList();
      });
    } catch (error) {
      print(error.toString());
      throw Failure(message: 'Something went wrong :(');
    }
  }

  Future<void> addPublicTodo(PublicTodo todo) async {
    try {
      await publicTodos.doc(todo.todoId).set(todo.toMap());
    } catch (error) {
      print(error.toString());
      throw Failure(message: 'Something went wrong try again :(');
    }
  }

  Future<void> deleteTodo(PublicTodo todoToDelete) async {
    try {
      if (todoToDelete.authorId == _currentUserId) {
        await publicTodos.doc(todoToDelete.todoId).delete();
      }
    } catch (error) {
      print(error.toString());
      throw Failure(message: 'Something went wrong');
    }
  }
}
