import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_todo/config/paths.dart';
import 'package:flutter_todo/models/app_user_model.dart';

class ProfileRepository {
  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection(Paths.users);
  final CollectionReference _publicTodo =
      FirebaseFirestore.instance.collection(Paths.public);

  Stream<AppUser?> streamUser(String? userId) {
    try {
      return _userRef
          .doc(userId)
          .snapshots()
          .map((doc) => AppUser.fromMap(doc.data()!));
    } catch (error) {
      print('Error getting getUser ${error.toString()}');
      throw error;
    }
  }

  Future<AppUser?> getUser(String userId) async {
    AppUser? appUser;
    try {
      final data = await _userRef.doc(userId).get();
      if (data.data() != null) {
        appUser = AppUser.fromMap(data.data()!);
      }
      return appUser;
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> updateProfile(AppUser appUser, String userId) async {
    try {
      _userRef.doc(userId).update(appUser.toMap());
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  // Future<Map<AppUser, int>> leadboard() async {
  //   Map<AppUser, int> leadBoard = {};
  //   try {
  //     final data = await _publicTodo.get();
  //     data.docs.forEach((element) async {
  //       final user = await getUser(element.data()['authorId']);
  //       print('-------I am user $user');
  //       if (user != null) {
  //         if (leadBoard.containsKey(user)) {
  //           leadBoard[user] = leadBoard[user]! + 1;
  //         } else {
  //           leadBoard[user] = 0;
  //         }
  //       }
  //     });

  //     return leadBoard;
  //   } catch (error) {
  //     print(error.toString());
  //     throw error;
  //   }
  // }

  Future<Map<String, int>> leadBoard() async {
    Map<String, int> leadBoard = {};
    try {
      final data = await _publicTodo.get();
      data.docs.forEach((element) async {
        final userId = element.data()['authorId'];
        if (userId != null) {
          if (leadBoard.containsKey(userId)) {
            leadBoard[userId] = leadBoard[userId]! + 1;
          } else {
            leadBoard[userId] = 1;
          }
        }
      });

      return leadBoard;
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
