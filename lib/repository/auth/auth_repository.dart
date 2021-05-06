import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_todo/models/app_user_model.dart';
import 'package:flutter_todo/models/failure_model.dart';
import 'package:flutter_todo/repository/auth/base_auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository extends BaseAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AppUser? _appUser(User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      name: user.displayName,
      imageUrl: user.photoURL,
    );
  }

  @override
  Stream<AppUser?> get onAuthChanges =>
      _firebaseAuth.userChanges().map((user) => _appUser(user));

  @override
  Future<AppUser?> get currentUser async => _appUser(_firebaseAuth.currentUser);

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
          await FirebaseAuth.instance.signInWithCredential(credential);
      return _appUser(userCredential.user);
    } on FirebaseAuthException catch (error) {
      throw Failure(code: error.code, message: error.message!);
    } on PlatformException catch (error) {
      throw Failure(code: error.code, message: error.message!);
    } catch (error) {
      throw Failure(message: 'Something went wrong.Try again');
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await GoogleSignIn().signOut();
  }
}
