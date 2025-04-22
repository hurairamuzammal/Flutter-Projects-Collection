import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign in
  Future<String> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.reload();

      if (!userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();

        return "not verified";
      } else {
        return "Login successful";
      }
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  // Sign up
  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await userCredential.user!.sendEmailVerification();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Forgot password
  Future<String> forgetPassword({required String email}) async {
    String res = "Error";
    try {
      await _auth.sendPasswordResetEmail(email: email);
      res = "Reset link sent to your email";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
