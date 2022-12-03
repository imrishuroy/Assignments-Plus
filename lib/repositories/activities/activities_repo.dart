import 'package:assignments/config/paths.dart';
import 'package:assignments/models/activity.dart';
import 'package:assignments/models/failure_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivitiesRepository {
  final _firebaseFirestore = FirebaseFirestore.instance;

  // ActivitiesRepository({FirebaseFirestore? firebaseFirestore})
  //     : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  Stream<List<Future<Activity?>>> getAllActivites() {
    try {
      return _firebaseFirestore
          .collection(Paths.activities)
          .orderBy('dateTime', descending: true)
          .snapshots()
          .map((snap) {
        print('I am running');
        return snap.docs.map((doc) => Activity.fromDocument(doc)).toList();
        //return snap.docs.map((e) => Activity.fromMap(e.data())).toList();
      });
    } catch (error) {
      print('Error getting activites ${error.toString()}');
      throw Failure(message: 'Error getting activites');
    }
  }
}
