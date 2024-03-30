import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notes/style/app_style.dart';
import 'package:intl/intl.dart';
import 'package:keep_notes/widgets/date_time.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({Key? key}) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  int Color_id = Random().nextInt(AppStyle.cardColor.length);
  TextEditingController _titleController = TextEditingController();
  TextEditingController _mainController = TextEditingController();
  late DateTime currentDate;

  @override
  void initState() {
    super.initState();
    currentDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateTimeHelper.formatDate(currentDate);

    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: AppStyle.cardColor[Color_id],
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          title: Text(
            "Add a new Note",
            style: GoogleFonts.poppins(color: Colors.black),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note Title',
                  hintStyle: GoogleFonts.poppins(
                      color: AppStyle.cardColor[Color_id],
                      fontWeight: FontWeight.bold),
                ),
                style: GoogleFonts.poppins(
                  color: AppStyle.cardColor[Color_id],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                formattedDate,
                style: GoogleFonts.poppins(
                  color: AppStyle.cardColor[Color_id],
                ),
              ),
              SizedBox(
                height: 28.0,
              ),
              TextField(
                controller: _mainController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Note content',
                  hintStyle: GoogleFonts.poppins(
                    color: AppStyle.cardColor[Color_id],
                  ),
                ),
                style: GoogleFonts.poppins(
                  color: AppStyle.cardColor[Color_id],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppStyle.cardColor[Color_id],
          onPressed: () async {
            FirebaseFirestore.instance.collection("Notes").add({
              "note_title": _titleController.text,
              "creation_date": formattedDate,
              "note_content": _mainController.text,
              "color_id": Color_id
            }).then((value) {
              print(value.id);
              Navigator.pop(context);
            }).catchError(
                (error) => print("Failed to add new note due to $error"));
          },
          label: Text(
            'Save',
            style: GoogleFonts.poppins(color: AppStyle.bgColor2, fontSize: 17),
          ),
        ));
  }
}
