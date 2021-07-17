import 'package:assignments/models/app_user_model.dart';

abstract class BaseAuthRepository {
  Future<AppUser?> signInWithGoogle();
  Future<AppUser?> signInWithPhone(String phoneNumber);
  Future<AppUser?> get currentUser;
  Stream<AppUser?> get onAuthChanges;
  Future<void> signOut();
}
