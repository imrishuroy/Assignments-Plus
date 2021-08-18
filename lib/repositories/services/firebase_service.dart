import 'package:assignments/config/paths.dart';
import 'package:assignments/models/contact_us.dart';
import 'package:assignments/models/failure_model.dart';
import 'package:assignments/models/purchase.dart';

import 'package:assignments/screens/leadBoard/lead_board.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseServices {
  final CollectionReference _users =
      FirebaseFirestore.instance.collection('leadBoard');

  final CollectionReference _contact =
      FirebaseFirestore.instance.collection(Paths.contact);

  final _fireStore = FirebaseFirestore.instance;

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

  Future<void> sendContactUsInformation(ContactUs contactUs) async {
    try {
      await _contact.add(contactUs.toMap());
    } catch (error) {
      print('Error sending contact us information ${error.toString()}');
      throw Failure(message: 'Something went wrong');
    }
  }

  Stream<List<Purchase?>> queryPurchase() {
    try {
      return _fireStore.collection('purchases').snapshots().map((snaps) {
        return snaps.docs.map((doc) => Purchase.fromMap(doc.data())).toList();
      });
    } catch (error) {
      print('Error query purchases ${error.toString()}');
      throw error;
    }
  }
}
