// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User?> get onAuthStateChanged => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<String?> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> changePassword(String oldPassword, String newPassword) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: _firebaseAuth.currentUser!.email!, password: oldPassword);
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
      return "SUCCES";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}