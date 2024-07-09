import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo/styles/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  final QueryDocumentSnapshot doc;

  NoteReaderScreen(this.doc, this.userId, {Key? key}) : super(key: key);
  final userId;
  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  late TextEditingController _noteContentController;

  @override
  void initState() {
    super.initState();
    _noteContentController =
        TextEditingController(text: widget.doc["note_content"]);
  }

  @override
  void dispose() {
    _noteContentController.dispose();
    super.dispose();
  }

  // Save note content to Firestore
  void _saveNoteContent() async {
    try {
      // Reference to the specific note document in the user's notes subcollection
      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId) // Ensure this field exists and is correct
          .collection("notes")
          .doc(widget.doc.id);

      if ((await docRef.get()).exists) {
        await docRef.update({"note_content": _noteContentController.text});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Note updated successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Document does not exist")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update note")),
      );
      print("Failed to update note: $error");
    }
  }

  // Delete note from Firestore
  void _deleteNote() async {
    //we will get user id from login and home screeen so
    try {
      final docRef = FirebaseFirestore.instance
          .collection("users")
          .doc(widget.userId)
          .collection("notes")
          .doc(widget.doc.id);

      if ((await docRef.get()).exists) {
        await docRef.delete();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Note deleted successfully")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Document does not exist")),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete note")),
      );
      print("Failed to delete note: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    int colorId = int.tryParse(widget.doc['color_id'].toString()) ?? 0;

    return Scaffold(
      backgroundColor: AppStyle.cardColors[colorId],
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: AppStyle.cardColors[colorId],
        foregroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: _deleteNote,
            icon: const Icon(Icons.delete_outline_outlined),
          ),
          IconButton(
            onPressed: _saveNoteContent,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.doc["notes_title"],
              style: AppStyle.mainTitle,
            ),
            const SizedBox(height: 4),
            Text(
              widget.doc["creation_date"],
              style: AppStyle.dateTitle,
            ),
            const SizedBox(height: 35),
            TextField(
              controller: _noteContentController,
              style: AppStyle.maincontent,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Edit Note Content",
                border: InputBorder.none,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
