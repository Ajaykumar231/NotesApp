import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyle {
  static Color bgColor = Color(0xff252526);
  static Color bgColor2 = Color(0xff1e1e1e);
  static Color maincolor = Color(0xff0098ff);

  //setting the cards different Color

  static List<Color> cardColor = [
    Colors.grey,
    Colors.red.shade100,
    Colors.grey.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.blueGrey.shade100,
    const Color(0xff0098ff)
  ];

  //setting text style

  static TextStyle mainTitle = GoogleFonts.poppins(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: AppStyle.maincolor);

  static TextStyle mainContent = GoogleFonts.poppins(
      fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.black);

  static TextStyle dateTitle =
      GoogleFonts.poppins(fontSize: 13.0, fontWeight: FontWeight.w500);
}
