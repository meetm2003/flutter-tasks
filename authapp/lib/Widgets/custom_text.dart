import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum TextType { title, heading, content }

class CustomText extends StatelessWidget {
  final String text;
  final TextType type;
  final TextAlign? textAlign;
  final Color? color;

  const CustomText({
    required this.text,
    required this.type,
    this.textAlign,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;
    TextAlign defaultTextAlign;

    switch (type) {
      case TextType.title:
        textStyle = GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black,
        );
        defaultTextAlign = TextAlign.left;
        break;
      case TextType.heading:
        textStyle = GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black,
        );
        defaultTextAlign = TextAlign.left;
        break;
      case TextType.content:
        textStyle = GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: color ?? Colors.black,
        );
        defaultTextAlign = TextAlign.justify;
        break;
    }

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign ?? defaultTextAlign,
    );
  }
}