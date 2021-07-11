import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_todo/config/paths.dart';
import 'package:flutter_todo/models/app_user_model.dart';

class ProfileRepository {
  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection(Paths.users);

  ///final _user = FirebaseAuth.instance.currentUser;
  // Future<AppUser?> getUser(String? userId) async {
  //   AppUser? appUser;
  //   try {
  //     final user = await _userRef.doc(userId).get();
  //     final userData = user.data();
  //     if (userData != null) {
  //       appUser = AppUser.fromMap(userData);
  //     }
  //     return appUser;
  //   } catch (error) {
  //     print('Error getting getUser ${error.toString()}');
  //     throw error;
  //   }
  // }

  Stream<AppUser?> streamUser(String? userId) {
    print('this runsssss---------');
    print('-------------UID from profil $userId');

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

  Future<void> updateProfile(AppUser appUser, String userId) async {
    try {
      _userRef.doc(userId).update(appUser.toMap());
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }
}
