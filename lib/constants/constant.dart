import 'package:flutter/material.dart';

class AppConstants {

  static const primaryColor = Color(0xFF6C63FF);
  static const secondaryColor = Color(0xFFFF6584);
  static const backgroundColor = Color(0xFF1A1A2E);
  static const cardColor = Color(0xFF16213E);
  static const xColor = Color(0xFF00D9FF);
  static const oColor = Color(0xFFFF6584);

  // Gradients
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1A2E), Color(0xFF0F3460)],
  );

  static const winGradient = LinearGradient(
    colors: [Color(0xFF00D9FF), Color(0xFF6C63FF)],
  );


  static const animationDuration = Duration(milliseconds: 300);
  static const winAnimationDuration = Duration(milliseconds: 600);


  static const emojis = ['🔥', '😎', '🎉', '💪', '👏', '😱'];
}
