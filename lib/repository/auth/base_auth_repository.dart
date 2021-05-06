import 'package:flutter_todo/models/app_user_model.dart';

abstract class BaseAuthRepository {
  Future<AppUser?> signInWithGoogle();
  Future<AppUser?> get currentUser;
  Stream<AppUser?> get onAuthChanges;
  Future<void> signOut();
}
