// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:login_signup/Services/authen.dart';
// import 'package:login_signup/styles/app_style.dart';
// import 'package:login_signup/screens/widgets/button.dart';
// import 'package:login_signup/screens/widgets/textfield.dart';

// // NoteReaderScreen

// class NoteReaderScreen extends StatefulWidget {
//   NoteReaderScreen(this.doc, {super.key});
//   QueryDocumentSnapshot? doc;

//   @override
//   State<NoteReaderScreen> createState() => _NoteReaderScreenState();
// }

// class _NoteReaderScreenState extends State<NoteReaderScreen> {
//   late TextEditingController _noteContentController;

//   @override
//   void initState() {
//     super.initState();
//     _noteContentController = TextEditingController(text: widget.doc?["note_content"]);
//   }

//   @override
//   void dispose() {
//     _noteContentController.dispose();
//     super.dispose();
//   }

//   void _saveNoteContent() {
//     // Update the document in Firestore
//     FirebaseFirestore.instance.collection("Notes").doc(widget.doc?.id).update({
//       "note_content": _noteContentController.text,
//     }).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Note updated successfully")));
//     }).catchError((error) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to update note")));
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     int color_id = int.tryParse(widget.doc!['color_id'].toString()) ?? 0;
//     return Scaffold(
//       backgroundColor: AppStyle.cardColors[color_id],
//       appBar: AppBar(
//         elevation: 0.0,
//         backgroundColor: AppStyle.cardColors[color_id],
//         foregroundColor: Colors.black,
//         actions: [
//           IconButton(
//             onPressed: () {
//               // delete from firebase
//               FirebaseFirestore.instance.collection("Notes").doc(widget.doc?.id).delete().then((_) {
//                 Navigator.pop(context);
//               }).catchError((error) {
//                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Failed to delete note")));
//               });
//             },
//             icon: const Icon(Icons.delete_outline_outlined),
//           ),
//           IconButton(
//             onPressed: _saveNoteContent,
//             icon: const Icon(Icons.save),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               widget.doc?["notes_title"],
//               style: AppStyle.mainTitle,
//             ),
//             const SizedBox(height: 4),
//             Text(
//               widget.doc?["creation_date"],
//               style: AppStyle.dateTitle,
//             ),
//             const SizedBox(height: 35),
//             TextField(
//               controller: _noteContentController,
//               style: AppStyle.maincontent,
//               maxLines: null,
//               decoration: const InputDecoration(
//                 hintText: "Edit Note Content",
//                 border: InputBorder.none,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
