import '../../models/auth_user.dart';

/// The user closed the sign-in window.
class AuthCancelledException implements Exception {}

abstract class AuthRepository {
  Stream<AuthUser?> authStateChanges();
  Future<void> signInWithGoogle();
  Future<void> signOut();
}