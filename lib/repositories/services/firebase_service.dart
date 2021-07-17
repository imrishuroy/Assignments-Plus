import 'package:assignments/screens/leadBoard/lead_board.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('leadBoard');

  // Stream<LeadBoard> leadBoardUsers() async {

  Future<List<LeadBoard>> leadBoardUsers() async {
    List<LeadBoard> leadBoardUsers = [];
    try {
      final allUsers = await _users.get();
      allUsers.docs.forEach((element) {
        print(element.data());
        // LeadBoard user = LeadBoard.fromMap(element.data() as Map<String, dynamic>);
        //  leadBoardUsers.add(user);
      });

      // ---------- with streams ---------- //
      // final users = _users.snapshots();

      // await users.forEach((element) {
      //   print(element.docs.first['name']);
      // });
      return leadBoardUsers;
    } catch (e) {
      return leadBoardUsers;
    }
  }
}
