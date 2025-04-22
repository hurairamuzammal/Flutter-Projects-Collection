import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  LoginPage({super.key, required this.onTap});
  final void Function()? onTap;
  void loginFunc(BuildContext context) async {
    final AuthService auth = AuthService();
    try {
      // show  CircularProgressIndicator while loading;

      await auth.signInWithEmailAndPassword(
          _emailController.text, _pwController.text, context);
    } catch (e) {
      showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  e.toString(),
                  style: const TextStyle(fontSize: 17),
                ), //error message
                icon: const Icon(
                  Icons.error_rounded,
                  color: Colors.red,
                ),
              ));
    }
  }

  forgetPassword(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (context) {
          final double maxHeight = MediaQuery.of(context).size.height;
          return SizedBox(
            height: maxHeight * 0.7,
            child: Padding(
              //show text field to get email and a button to send reset link
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MyTextfield(
                      hintText: "Email",
                      obsure: false,
                      controller: _emailController),
                  const SizedBox(
                    height: 25,
                  ),
                  MyButton(
                      text: "Send Reset Link",
                      onTap: () async {
                        final AuthService auth = AuthService();
                        final String res = await auth.forgetPassword(
                            email: _emailController.text);
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(res),
                                ));
                      }),
                ],
              ),
            ),
          );
        });
  }

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
              Text("ChatOn",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 35,
                      fontWeight: FontWeight.w300)),
              const SizedBox(height: 50),
              //logo
              Icon(
                Icons.message_rounded,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 20),
              // welcome backmessage
              Text('Share your thoughts with friends with ChatOn',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 16)),
              const SizedBox(height: 10),
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
              //login button
              MyButton(text: "Login", onTap: () => loginFunc(context)),
              const SizedBox(
                height: 20,
              ),
              //add forget password button
              TextButton(
                  onPressed: () {
                    forgetPassword(context);
                  },
                  child: Text("Forget Password",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary))),
              //register new user
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member? ',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onPrimary)),
                  GestureDetector(
                    onTap: onTap, //navigate to register page
                    child: Text("Register Now",
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
