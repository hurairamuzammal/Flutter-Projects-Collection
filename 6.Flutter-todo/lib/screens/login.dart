import 'package:flutter/material.dart';
import 'package:flutter_todo/Services/authen.dart';
import 'package:flutter_todo/main.dart';
import 'package:flutter_todo/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_todo/screens/signup.dart';
import 'package:flutter_todo/screens/widgets/textfield.dart';
import 'package:flutter_todo/screens/widgets/button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUserFun() async {
    String res = await AuthServices().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "Logged In") {
      User? user = FirebaseAuth.instance.currentUser;
      String uid = user!.uid;

      setState(() {
        FocusScope.of(context).unfocus();
        emailController.clear();
        passwordController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Logged in successfully"),
          duration: Duration(seconds: 5),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(uid: uid),
        ),
      );
    } else {
      setState(() {
        FocusScope.of(context).unfocus();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

  void showForgotPasswordModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Ensures the modal sheet covers the entire screen
      builder: (context) {
        final TextEditingController forgotPasswordController =
            TextEditingController();

        void sendPasswordResetEmail() async {
          try {
            await FirebaseAuth.instance
                .sendPasswordResetEmail(email: forgotPasswordController.text);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Password reset email sent"),
                duration: Duration(seconds: 5),
              ),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to send password reset email"),
                duration: Duration(seconds: 5),
              ),
            );
          }
        }

        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Forgot Password',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextfieldInpute(
                  textEditingController: forgotPasswordController,
                  isPass: false,
                  hintText: "Enter Your Email",
                  icon: Icons.email_outlined,
                ),
                Mybutton(
                  onTab: sendPasswordResetEmail,
                  textS: "Send Reset Email",
                ),
                Mybutton(
                  onTab: () {
                    Navigator.pop(context);
                  },
                  textS: "Cancel",
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    double heightDevice = MediaQuery.of(context).size.height;

    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor:
      //       isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
      // ),
      backgroundColor:
          isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
      body: SafeArea(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 25),
                Text(
                  "Flutter To Do",
                  style: TextStyle(
                    color: isDarkMode
                        ? kDarkColorScheme.secondary
                        : kcolorScheme.secondary,
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                Text(
                  "by Huraira",
                  style: TextStyle(
                    color: isDarkMode
                        ? kDarkColorScheme.secondary
                        : kcolorScheme.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  height: heightDevice / 2.7,
                  child: Image.asset("assets/login2.png"),
                ),
                TextfieldInpute(
                  icon: Icons.email_outlined,
                  textEditingController: emailController,
                  isPass: false,
                  hintText: "Enter Your Email",
                ),
                const SizedBox(height: 10),
                TextfieldInpute(
                  icon: Icons.lock_outline,
                  textEditingController: passwordController,
                  isPass: true,
                  hintText: "Enter Your Password",
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: showForgotPasswordModal,
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
                Mybutton(
                  onTab: loginUserFun,
                  textS: "Login",
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Don't have an account ? ",
                        style: TextStyle(
                            color: isDarkMode
                                ? kDarkColorScheme.secondary
                                : kcolorScheme.secondary),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MySignUpScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Signup",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
