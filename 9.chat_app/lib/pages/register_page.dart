import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key, required this.onTap});
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  void register(BuildContext context) {
    // make auth service instance
    final auth = AuthService();

    if (_pwController.text == _confirmPwController.text) {
      try {
        auth.signUpWithEmailAndPassword(
            _emailController.text, _pwController.text);
      } catch (e) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(e.toString()), //error message
                ));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => const AlertDialog(
                icon: Icon(Icons.error),
                iconColor: Colors.red,
                title: Text("Passwords donot match"),
                titleTextStyle: TextStyle(
                    fontSize: 15, color: Colors.black), //error message
              ));
    }
  }

  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Icon(
                Icons.message_rounded,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              // welcome backmessage
              Text('Sign Up for the ChatOn',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16)),
              const SizedBox(height: 45),
              //email input
              MyTextfield(
                  hintText: "Email",
                  obsure: false,
                  controller: _emailController),

              const SizedBox(height: 10),
              //password input
              MyTextfield(
                  hintText: "Password",
                  obsure: true,
                  controller: _pwController),

              const SizedBox(
                height: 10,
              ),
              MyTextfield(
                  hintText: "Confirm Password",
                  obsure: true,
                  controller: _confirmPwController),

              const SizedBox(
                height: 60,
              ),
              //login button
              MyButton(
                  text: "Register",
                  onTap: () {
                    register(context);
                  }),
              const SizedBox(
                height: 20,
              ),
              //register new user
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimary)),
                  GestureDetector(
                    onTap: onTap, //navigate to login page
                    child: Text("Login now",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Theme.of(context).colorScheme.onPrimary)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
