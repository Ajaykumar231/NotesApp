import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:keep_notes/screens/note_reader.dart';
import 'package:keep_notes/style/app_style.dart';
import 'package:keep_notes/widgets/note_card.dart';
import 'package:google_fonts/google_fonts.dart';

class Search_screen extends StatefulWidget {
  //final QuerySnapshot notesSnapshot;
  Search_screen({Key? key}) : super(key: key);

  //const Search_screen({super.key});

  @override
  State<Search_screen> createState() => _Search_screenState();
}

class _Search_screenState extends State<Search_screen> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    bool isSearching = false;
    // Assuming you have a method to fetch the QuerySnapshot from Firebase, you can use it like this
    Future<QuerySnapshot> fetchNotes() async {
      // Replace this with your actual Firestore query
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('Notes').get();
      return snapshot;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: Navigator.canPop(context)
            ? IconButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        leadingWidth: 30,
        elevation: 0,
        backgroundColor: Colors.black,
        title: Container(
          height: 40,
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: AppStyle.bgColor,
            borderRadius: BorderRadius.circular(50),
          ),
          child: TextField(
            style: GoogleFonts.poppins(color: Colors.white),
            autofocus: true,
            controller: _searchController, // Assign the TextEditingController
            decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: GoogleFonts.poppins(color: Colors.white),
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search) // Remove the border
                ),
            onChanged: (query) {
              setState(() {
                searchQuery = query;
                isSearching = query.isNotEmpty;
              });
            },
            onSubmitted: (value) {
              // Handle search or any other action when the user submits the TextField
              print('Search: $value');
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection("Notes").snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasData) {
                  final filteredNotes = snapshot.data!.docs.where((note) {
                    final title = note["note_title"].toString().toLowerCase();
                    return title.contains(searchQuery.toLowerCase());
                  }).toList();

                  return GridView(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    children: filteredNotes
                        .map((note) => noteCard(
                              context,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        NoteReaderScreen(note),
                                  ),
                                );
                              },
                              note,
                              () {
                                // Your delete logic
                              },
                            ))
                        .toList(),
                  );
                }

                // Filter notes based on searchQuery

                return Text(
                  "No notes found",
                  style: GoogleFonts.poppins(color: Colors.white),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
