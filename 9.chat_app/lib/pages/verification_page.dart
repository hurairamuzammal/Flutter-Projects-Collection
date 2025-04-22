import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/services/auth/auth_gate.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});
  @override
  VerificationPageState createState() => VerificationPageState();
}

class VerificationPageState extends State<VerificationPage> {
  late Timer timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.reload();
      if (user?.emailVerified == true) {
        timer.cancel();
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AuthGate()));
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Account Verification",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 40),
              Text(
                "An email for verification has been sent. Please verify to continue.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AuthGate(text: "cancel")));
                },
                child: Text(
                  'Go Back',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
