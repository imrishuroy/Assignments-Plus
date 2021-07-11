import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo/config/paths.dart';
import 'package:flutter_todo/models/app_user_model.dart';
import 'package:flutter_todo/models/failure_model.dart';
import 'package:flutter_todo/repositories/auth/base_auth_repository.dart';

import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final CollectionReference _userRef =
      FirebaseFirestore.instance.collection(Paths.users);

  AppUser? _appUser(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      name: user.displayName,
      imageUrl: user.photoURL,
      about: '',
      email: user.email,
    );
  }

  @override
  Stream<AppUser?> get onAuthChanges =>
      _firebaseAuth.userChanges().map((user) => _appUser(user));

  @override
  Future<AppUser?> get currentUser async => _appUser(_firebaseAuth.currentUser);

  String? get userId => _firebaseAuth.currentUser?.uid;

  String? get userImage => _firebaseAuth.currentUser?.photoURL;

  @override
  Future<AppUser?> signInWithGoogle() async {
    try {
// Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // Once signed in, return the UserCredential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // final user = await _userRef.doc(userCredential.user?.uid).get();

      // print('User Exists ---- ${user.exists}');

      // if (!user.exists) {
      //   _userRef.doc(userCredential.user?.uid).set({
      //     'name': userCredential.user?.displayName ?? '',
      //     'imageUrl': userCredential.user?.photoURL,
      //     'about': '',
      //     'email': userCredential.user?.email ?? ''
      //   });
      // }

      return _appUser(userCredential.user);
    } on FirebaseAuthException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      print(error.toString());
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      throw Failure(message: 'Something went wrong.Try again');
    }
  }

  Future<AppUser?> getUser(String? userId) async {
    AppUser? appUser;
    try {
      final user = await _userRef.doc(userId).get();
      final userData = user.data();
      if (userData != null) {
        appUser = AppUser.fromMap(userData);
      }
      return appUser;
    } catch (error) {
      print('Error getting getUser ${error.toString()}');
      throw error;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Future<AppUser?> signInWithPhone(String phoneNumber) async {
    late UserCredential? userCredential;
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        userCredential = await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        print('AuthException- $e');
      },
      codeSent: (String? verificationId, int? resendToken) {
        print('VerificationID - $verificationId');
        print('Resend Token- $resendToken');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print('codeAutoRetrievalTimeout VerificationID $verificationId');
      },
    );
    return _appUser(userCredential != null ? userCredential!.user : null);
  }
}
