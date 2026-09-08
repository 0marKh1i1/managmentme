import 'package:flutter/material.dart';

class ContrastColor {
  static Color getContrastBlackWhite(Color background){
    Color foreground = background.computeLuminance() > 0.5 
    ? Colors.black 
    : Colors.white;
  return foreground;
  }
}
