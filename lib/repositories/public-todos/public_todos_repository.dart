import 'package:assignments/config/paths.dart';
import 'package:assignments/enums/activity_type.dart';
import 'package:assignments/models/activity.dart';
import 'package:assignments/models/app_user_model.dart';
import 'package:assignments/models/failure_model.dart';
import 'package:assignments/models/public_todos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class PublicTodosRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;

  final CollectionReference _publicTodos =
      FirebaseFirestore.instance.collection(Paths.public);

  Stream<List<PublicTodo>> allTodos() {
    try {
      return _publicTodos
          .orderBy('dateTime', descending: true)
          .snapshots()
          .map((snaps) {
        return snaps.docs
            .map(
                (doc) => PublicTodo.fromMap(doc.data() as Map<String, dynamic>))
            .toList();
      });
    } catch (error) {
      print(error.toString());
      throw Failure(message: 'Something went wrong :(');
    }
  }

  Future<bool> checkPublicTodoAlreadyExists(String? publicTodoId) async {
    bool _exists = false;
    try {
      final todo = await _publicTodos.doc(publicTodoId).get();
      if (todo.exists) {
        print('this exists ');
        _exists = true;
      }

      return _exists;
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  Future<void> addPublicTodo(PublicTodo publicTodo) async {
    try {
      final id = Uuid().v4();
      await _firebaseFirestore
          .collection(Paths.public)
          .doc(id)
          .set(publicTodo.toMap());
      // await _publicTodos.doc(publicTodo.todoId).set(publicTodo.toMap());

      final activity = Activity(
        id: id,
        type: ActivityType.newPost,
        fromUser: AppUser.emptyUser.copyWith(uid: publicTodo.authorId),
        //todo: publicTodo,
        todo: PublicTodo.empty.copyWith(todoId: id),
        dateTime: DateTime.now(),
      );

      await _firebaseFirestore
          .collection(Paths.activities)
          .doc(id)
          .set(activity.toMap());
    } catch (error) {
      print(error.toString());
      throw Failure(message: 'Something went wrong try again :(');
    }
  }

  Future<void> deleteTodo(
      PublicTodo todoToDelete, String? currentUserId) async {
    try {
      if (todoToDelete.authorId == currentUserId) {
        await _publicTodos.doc(todoToDelete.todoId).delete();
      }
    } catch (error) {
      print(error.toString());
      throw Failure(message: 'Something went wrong');
    }
  }

  Future<void> deleteTodoById(String? publicTodoId) async {
    try {
      await _publicTodos.doc(publicTodoId).delete();
    } catch (error) {
      print(error.toString());
      throw Failure(message: 'Something went wrong');
    }
  }

  Future<void> updatePublicTodo(
      PublicTodo todoToUpdate, String? currentUserId) async {
    try {
      if (todoToUpdate.authorId == currentUserId) {
        await _publicTodos
            .doc(todoToUpdate.todoId)
            .update(todoToUpdate.toMap());
      }
    } catch (error) {
      throw Failure(message: error.toString());
    }
  }
}
