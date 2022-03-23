import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomStyles {
  TextStyle getStyleFont(_color, _size) {
    return GoogleFonts.openSans(
        textStyle: TextStyle(color: _color, fontSize: _size));
  }

  TextStyle getStyleFontWithFontWeight(_color, _size, _fontWeight) {
    return GoogleFonts.openSans(
        textStyle:
            TextStyle(color: _color, fontSize: _size, fontWeight: _fontWeight));
  }
}
