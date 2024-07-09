import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Error";
    try {
      if (email.isEmpty || password.isEmpty || name.isEmpty) {
        res = "Please fill all the fields";
        return "Please fill all the fields";
      }
      // Create a new user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user data in Firestore
      await _firestore.collection("users").doc(userCredential.user!.uid).set({
        "name": name,
        "email": email,
        "uid": userCredential.user!.uid,
      });

      res = "Signed Up";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        res = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        res = 'The account already exists for that email.';
      } else {
        res = e.message ?? 'An unknown error occurred.';
      }
    } catch (e) {
      res = e.toString();
    }

    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Error";
    try {
      if (email.isEmpty || password.isEmpty) {
        res = "Please fill all the fields";
        return "Please fill all the fields";
      }
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      res = "Logged In";
    } catch (e) {
      return res = e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

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

  Future<String> verifyUser() async {
    String res = "Error";
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        res = "Verification email sent";
      } else {
        res = "No user is currently signed in.";
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
