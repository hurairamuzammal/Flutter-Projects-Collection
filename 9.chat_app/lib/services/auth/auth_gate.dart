import 'package:chat_app/pages/verification_page.dart';
import 'package:chat_app/services/auth/login_or_register.dart';
import 'package:chat_app/pages/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthGate extends StatelessWidget {
  String? text = "null";
  AuthGate({super.key, this.text});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData) {
            return const LoginOrRegister();
          } else if (snapshot.hasData && text == "cancel") {
            //delete snapshot.data
            FirebaseAuth.instance.signOut();
            text = "null";
            return const LoginOrRegister();
          } else {
            final user = snapshot.data as User?;
            if (user != null && !user.emailVerified) {
              return const VerificationPage();
            } else {
              return HomePage();
            }
          }
        },
      ),
    );
  }
}
