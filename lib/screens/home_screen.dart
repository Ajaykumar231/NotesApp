import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notes/screens/note_editor.dart';
import 'package:keep_notes/screens/note_reader.dart';
import 'package:keep_notes/screens/search_screen.dart';
import 'package:keep_notes/style/app_style.dart';
import 'package:keep_notes/widgets/note_card.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Define the onDelete callback function
  void onDelete(String documentId) {
    // Implement the logic to delete the note from Firestore using the documentId
    FirebaseFirestore.instance.collection("Notes").doc(documentId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.bgColor2,
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Note'z",
          style: GoogleFonts.poppins(
              color: AppStyle.maincolor,
              fontWeight: FontWeight.w600,
              fontSize: 30),
        ),
        backgroundColor: AppStyle.bgColor2,
      ),
      body: LiquidPullToRefresh(
        backgroundColor: AppStyle.maincolor,
        color: AppStyle.bgColor2,
        onRefresh: () async {
          // Reload data from Firestore
          try {
            // Initialize Firebase if not already initialized
            await Firebase.initializeApp();
            // Fetch the updated data from Firestore
            QuerySnapshot querySnapshot =
                await FirebaseFirestore.instance.collection("Notes").get();
          } catch (e) {
            // Handle any potential errors
            print("Error reloading data: $e");
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return Search_screen();
                    } // Replace with your screen
                        ),
                  );
                },
                child: Container(
                    height: 50,
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppStyle.bgColor,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        "Search your notes....",
                        textAlign: TextAlign.start,
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    )),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "Your recent Notes...",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 19,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("Notes")
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData) {
                      return GridView(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        children: snapshot.data!.docs
                            .map((note) => noteCard(
                                context,
                                () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NoteReaderScreen(note),
                                      ));
                                },
                                note,
                                () {
                                  onDelete(note.id);
                                }))
                            .toList(),
                      );
                    }
                    return Text(
                      "there's no Notes",
                      style: GoogleFonts.nunito(color: Colors.white),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppStyle.maincolor,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const NoteEditorScreen()));
        },
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
