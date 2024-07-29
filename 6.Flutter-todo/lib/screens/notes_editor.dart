import 'dart:math';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:flutter_todo/styles/app_style.dart';

class NoteEditorScreen extends StatefulWidget {
  final String uid;

  const NoteEditorScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  int color_id = Random().nextInt(AppStyle.cardColors.length);
  String dateNow = DateTime.now().toString().substring(0, 16);
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainContent = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardColors[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardColors[color_id],
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Add a note",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Note Title',
                    hintStyle:
                        TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
                    fillColor: Colors.black),
                style: AppStyle.mainTitle,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                dateNow,
                style: AppStyle.dateTitle,
              ),
              const SizedBox(
                height: 28,
              ),
              TextField(
                controller: _mainContent,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note Content',
                  hintStyle: TextStyle(color: Color.fromARGB(255, 88, 88, 88)),
                ),
                style: AppStyle.maincontent,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.accentColor,
        onPressed: () async {
          // save note
          FirebaseFirestore.instance
              .collection("users")
              .doc(widget.uid)
              .collection("notes")
              .add({
            "notes_title": _titleController.text,
            "note_content": _mainContent.text,
            "creation_date": dateNow,
            "color_id": color_id,
          }).then((value) {
            Navigator.pop(context);
          }).catchError((error) {
            print("Failed to add note: $error");
          });
        },
        tooltip: 'Save note ',
        child: const Icon(
          Icons.save,
        ),
      ),
    );
  }
}
