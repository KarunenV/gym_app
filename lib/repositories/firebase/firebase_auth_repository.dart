import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../models/auth_user.dart';
import '../base/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const _cancelCodes = {
    'popup-closed-by-user',
    'cancelled-popup-request',
    'web-context-canceled',
    'canceled',
  };

  @override
  Stream<AuthUser?> authStateChanges() => _auth.authStateChanges().map((u) {
    final email = u?.email;
    if (u == null || email == null) return null;
    return AuthUser(uid: u.uid, email: email);
  });

  @override
  Future<void> signInWithGoogle() async {
    final provider = GoogleAuthProvider()
      ..setCustomParameters({'prompt': 'select_account'});

    try {
      if (kIsWeb) {
        await _auth.signInWithPopup(provider);
      } else {
        await _auth.signInWithProvider(provider);
      }
    } on FirebaseAuthException catch (e) {
      if (_cancelCodes.contains(e.code)) throw AuthCancelledException();
      rethrow;
    }
  }

  @override
  Future<void> signOut() => _auth.signOut();
}