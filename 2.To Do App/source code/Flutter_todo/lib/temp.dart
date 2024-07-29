// // //login temp
// // import 'package:flutter/material.dart';
// // import 'package:login_signup/Services/authen.dart';
// // import 'package:login_signup/main.dart';
// // import 'package:login_signup/screens/signup.dart';
// // import 'package:login_signup/screens/widgets/textfield.dart';
// // import 'package:login_signup/screens/widgets/button.dart';
// // import 'package:login_signup/screens/home_screen.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// // class LoginScreen extends StatefulWidget {
// //   const LoginScreen({super.key});

// //   @override
// //   State<LoginScreen> createState() => _loginScreenState();
// // }

// // class _loginScreenState extends State<LoginScreen> {
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();

// //   void loginUserFun() async {
// //     String res = await AuthServices().loginUser(
// //       email: emailController.text,
// //       password: passwordController.text,
// //     );

// //     if (res == "Logged In") {
// //       User? user = FirebaseAuth.instance.currentUser;
// //       String uid = user!.uid;

// //       setState(() {
// //         FocusScope.of(context).unfocus();
// //         emailController.clear();
// //         passwordController.clear();
// //       });

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text("Logged in successfully"),
// //           duration: Duration(seconds: 5),
// //         ),
// //       );

// //       Navigator.pushReplacement(
// //         context,
// //         MaterialPageRoute(
// //           builder: (context) => HomeScreen(uid: uid),
// //         ),
// //       );
// //     } else {
// //       setState(() {
// //         FocusScope.of(context).unfocus();
// //       });

// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(res),
// //           duration: const Duration(seconds: 5),
// //         ),
// //       );
// //     }
// //   }

// //   void showForgotPasswordModal() {
// //     showModalBottomSheet(
// //       context: context,
// //       builder: (context) {
// //         final TextEditingController forgotPasswordController = TextEditingController();

// //         void sendPasswordResetEmail() async {
// //           try {
// //             await FirebaseAuth.instance.sendPasswordResetEmail(email: forgotPasswordController.text);
// //             Navigator.pop(context);
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               const SnackBar(
// //                 content: Text("Password reset email sent"),
// //                 duration: Duration(seconds: 5),
// //               ),
// //             );
// //           } catch (e) {
// //             ScaffoldMessenger.of(context).showSnackBar(
// //               const SnackBar(
// //                 content: Text("Failed to send password reset email"),
// //                 duration: Duration(seconds: 5),
// //               ),
// //             );
// //           }
// //         }

// //         return Padding(
// //           padding: const EdgeInsets.all(16.0),
// //           child: Column(
// //             mainAxisSize: MainAxisSize.min,
// //             children: [
// //               Text(
// //                 'Forgot Password',
// //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //               ),
// //               const SizedBox(height: 16),
// //               TextfieldInpute(
// //                 textEditingController: forgotPasswordController,
// //                 isPass: false,
// //                 hintText: "Enter Your Email",
// //                 icon: Icons.email_outlined,
// //               ),
// //               const SizedBox(height: 16),
// //               Mybutton(
// //                 onTab: sendPasswordResetEmail,
// //                 textS: "Send Reset Email",
// //               ),
// //               const SizedBox(height: 16),
// //               ElevatedButton(
// //                 onPressed: () {
// //                   Navigator.pop(context);
// //                 },
// //                 child: Text('Cancel'),
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     bool isdarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
// //     double height = MediaQuery.of(context).size.height;
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor: isdarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
// //       ),
// //       backgroundColor: isdarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
// //       body: SafeArea(
// //         child: SizedBox(
// //           child: SingleChildScrollView(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   "Flutter Notes",
// //                   style: TextStyle(
// //                     color: isdarkMode ? kDarkColorScheme.secondary : kcolorScheme.secondary,
// //                     fontSize: 25,
// //                     fontWeight: FontWeight.w300,
// //                   ),
// //                 ),
// //                 Text(
// //                   "by Huraira",
// //                   style: TextStyle(
// //                     color: isdarkMode ? kDarkColorScheme.secondary : kcolorScheme.secondary,
// //                     fontSize: 12,
// //                     fontWeight: FontWeight.w300,
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 SizedBox(
// //                   width: double.infinity,
// //                   height: height / 2.7,
// //                   child: Image.asset("assets/login2.png"),
// //                 ),
// //                 TextfieldInpute(
// //                   icon: Icons.email_outlined,
// //                   textEditingController: emailController,
// //                   isPass: false,
// //                   hintText: "Enter Your Email",
// //                 ),
// //                 const SizedBox(height: 20),
// //                 TextfieldInpute(
// //                   icon: Icons.lock_outline,
// //                   textEditingController: passwordController,
// //                   isPass: true,
// //                   hintText: "Enter Your Password",
// //                 ),
// //                 Padding(
// //                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
// //                   child: Align(
// //                     alignment: Alignment.centerRight,
// //                     child: TextButton(
// //                       onPressed: showForgotPasswordModal,
// //                       child: const Text(
// //                         "Forgot Password?",
// //                         style: TextStyle(
// //                           color: Colors.blue,
// //                           fontSize: 14,
// //                         ),
// //                       ),
// //                     ),
// //                   ),
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Mybutton(
// //                   onTab: loginUserFun,
// //                   textS: "Login",
// //                 ),
// //                 const SizedBox(height: 20),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     Container(
// //                       padding: const EdgeInsets.symmetric(vertical: 8),
// //                       child: Text(
// //                         "Don't have an account ? ",
// //                         style: TextStyle(color: isdarkMode ? kDarkColorScheme.secondary : kcolorScheme.secondary),
// //                       ),
// //                     ),
// //                     GestureDetector(
// //                       onTap: () {
// //                         Navigator.push(
// //                           context,
// //                           MaterialPageRoute(
// //                             builder: (context) => const MySignUpScreen(),
// //                           ),
// //                         );
// //                       },
// //                       child: Container(
// //                         padding: const EdgeInsets.symmetric(vertical: 8),
// //                         child: const Text(
// //                           "Signup",
// //                           style: TextStyle(
// //                             color: Colors.blue,
// //                             fontWeight: FontWeight.bold,
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }


// // // // signup temp

// // //orignal sign up
// // import 'package:flutter/material.dart';
// // import 'package:login_signup/Services/authen.dart';
// // import 'package:login_signup/main.dart';
// // import 'package:login_signup/screens/widgets/button.dart';
// // import 'package:login_signup/screens/widgets/textfield.dart';

// // class MySignUpScreen extends StatefulWidget {
// //   const MySignUpScreen({super.key});

// //   @override
// //   State<MySignUpScreen> createState() => _signUpScreenState();
// // }

// // class _signUpScreenState extends State<MySignUpScreen> {
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController nameController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();

// //   void signUpUser() async {
// //     String res = await AuthServices().signUpUser(
// //       email: emailController.text,
// //       password: passwordController.text,
// //       name: nameController.text,
// //     );

// //     // if user is signed up successfully
// //     if (res == "Signed Up") {
// //       setState(() {
// //         // close keyboard
// //         FocusScope.of(context).unfocus();
// //         emailController.clear();
// //         passwordController.clear();
// //         nameController.clear();
// //       });

// //       // Show snackbar for success message
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(
// //           content: Text("User signed up successfully"),
// //           duration: Duration(seconds: 5),
// //         ),
// //       );

// //       // Navigate to login screen
// //       Navigator.pop(context);
// //     } else {
// //       setState(() {
// //         FocusScope.of(context).unfocus();
// //       });

// //       // Show snackbar for error message
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(
// //           content: Text(res),
// //           duration: const Duration(seconds: 5),
// //         ),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     double height = MediaQuery.of(context).size.height;
// //     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
// //     return Scaffold(
// //       appBar: AppBar(
// //         backgroundColor:
// //             isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
// //       ),
// //       backgroundColor:
// //           isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
// //       body: SafeArea(
// //         child: SizedBox(
// //           child: SingleChildScrollView(
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 SizedBox(
// //                   width: double.infinity,
// //                   height: height / 2.7,
// //                   child: Image.asset("assets/signup2.png"),
// //                 ),
// //                 TextfieldInpute(
// //                   textEditingController: nameController,
// //                   isPass: false,
// //                   hintText: "Name",
// //                   icon: Icons.person_2_outlined,
// //                 ),
// //                 const SizedBox(
// //                   height: 10,
// //                 ),
// //                 TextfieldInpute(
// //                   textEditingController: emailController,
// //                   isPass: false,
// //                   hintText: "Email",
// //                   icon: Icons.email_outlined,
// //                 ),
// //                 const SizedBox(
// //                   height: 10,
// //                 ),
// //                 TextfieldInpute(
// //                   textEditingController: passwordController,
// //                   isPass: true,
// //                   hintText: "Password",
// //                   icon: Icons.lock_outline,
// //                 ),
// //                 const SizedBox(
// //                   height: 10,
// //                 ),
// //                 Mybutton(
// //                   onTab: signUpUser,
// //                   textS: "Sign Up",
// //                 ),
// //                 const SizedBox(
// //                   height: 20,
// //                 ),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.center,
// //                   children: [
// //                     const Text(
// //                       "Already have an account ?  ",
// //                       style: TextStyle(
// //                         color: Colors.grey,
// //                         fontSize: 16,
// //                       ),
// //                     ),
// //                     GestureDetector(
// //                       onTap: () {
// //                         // pop the current screen
// //                         Navigator.pop(context);
// //                       },
// //                       child: const Text(
// //                         "Log in",
// //                         style: TextStyle(
// //                           color: Colors.blue,
// //                           fontSize: 16,
// //                           fontWeight: FontWeight.bold,
// //                         ),
// //                       ),
// //                     )
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:login_signup/Services/authen.dart';
// import 'package:login_signup/main.dart';
// import 'package:login_signup/screens/widgets/button.dart';
// import 'package:login_signup/screens/widgets/textfield.dart';

// class MySignUpScreen extends StatefulWidget {
//   const MySignUpScreen({super.key});

//   @override
//   State<MySignUpScreen> createState() => _signUpScreenState();
// }

// class _signUpScreenState extends State<MySignUpScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   bool _isEmailSent = false; // Track if email verification is sent

//   void signUpUser() async {
//     String verificationRes = await AuthServices().verifyUser(
//       );

//     if (verificationRes == "Verification email sent") {
//       // Email sent successfully, proceed to sign up
//       String res = await AuthServices().signUpUser(
//         email: emailController.text,
//         password: passwordController.text,
//         name: nameController.text,
//       );

//       if (res == "Signed Up") {
//         setState(() {
//           _isEmailSent = true;
//         });

//         // Clear text fields after successful sign up
//         setState(() {
//           FocusScope.of(context).unfocus();
//           emailController.clear();
//           passwordController.clear();
//           nameController.clear();
//         });
//       } else {
//         // Show snackbar for sign up failure
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text(res),
//             duration: Duration(seconds: 5),
//           ),
//         );
//       }
//     } else {
//       // Show snackbar for any other error during email verification
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text(verificationRes),
//           duration: Duration(seconds: 5),
//         ),
//       );
//     }
//   }

//   void showEmailVerificationModal() {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(
//                 'Verify Email',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 'A verification email has been sent to ${emailController.text}. Please check your email and click on the verification link.',
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 16),
//               Mybutton(
//                 onTab: () {
//                   Navigator.pop(context);
//                 },
//                 textS: "Close",
//               ),
//             ],
//           ),
//         );
//       },
//     ).then((_) {
//       // Modal closed, check verification status if needed
//       // Typically, you would handle further actions after verification here
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double height = MediaQuery.of(context).size.height;
//     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor:
//             isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
//       ),
//       backgroundColor:
//           isDarkMode ? kDarkColorScheme.primary : kcolorScheme.primary,
//       body: SafeArea(
//         child: SizedBox(
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   width: double.infinity,
//                   height: height / 2.7,
//                   child: Image.asset("assets/signup2.png"),
//                 ),
//                 TextfieldInpute(
//                   textEditingController: nameController,
//                   isPass: false,
//                   hintText: "Name",
//                   icon: Icons.person_2_outlined,
//                 ),
//                 const SizedBox(height: 10),
//                 TextfieldInpute(
//                   textEditingController: emailController,
//                   isPass: false,
//                   hintText: "Email",
//                   icon: Icons.email_outlined,
//                 ),
//                 const SizedBox(height: 10),
//                 TextfieldInpute(
//                   textEditingController: passwordController,
//                   isPass: true,
//                   hintText: "Password",
//                   icon: Icons.lock_outline,
//                 ),
//                 const SizedBox(height: 10),
//                 Mybutton(
//                   onTab: signUpUser,
//                   textS: "Sign Up",
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       "Already have an account ? ",
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 16,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: const Text(
//                         "Log in",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
