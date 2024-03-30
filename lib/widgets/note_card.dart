import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keep_notes/style/app_style.dart';

Widget noteCard(BuildContext context, Function()? onTap,
    QueryDocumentSnapshot doc, final VoidCallback onDelete) {
  return GestureDetector(
    onLongPress: () {
      // Show a confirmation dialog before deleting
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: AppStyle.bgColor,
            title: Text("Delete Note", style: AppStyle.mainTitle),
            content: Text("Are you sure you want to delete this note?",
                style: GoogleFonts.poppins(color: Colors.white)),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  // Dismiss the dialog
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  // Call the onDelete function when the user confirms the delete
                  Future<void> onDelete(String noteId) async {
                    try {
                      await FirebaseFirestore.instance
                          .collection("Notes")
                          .doc(noteId)
                          .delete();
                      print("Note deleted successfully");
                    } catch (e) {
                      print("Error deleting note: $e");
                    }
                  }

                  onDelete(doc.id);
                  // Dismiss the dialog
                  Navigator.of(context).pop();
                },
                child: Text("Delete"),
              ),
            ],
          );
        },
      );
    },
    child: InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: AppStyle.cardColor[doc['color_id']],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doc["note_title"],
              style: AppStyle.mainContent,
            ),
            SizedBox(height: 4.0),
            Expanded(
              child: Text(
                doc["note_content"],
                style: GoogleFonts.poppins(
                    fontSize: 15, fontWeight: FontWeight.w500),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              doc["creation_date"],
              style: AppStyle.dateTitle,
            ),
            SizedBox(
              height: 8.0,
            ),
          ],
        ),
      ),
    ),
  );
}
