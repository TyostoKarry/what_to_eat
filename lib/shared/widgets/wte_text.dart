import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class WTEText extends StatelessWidget {
  final String text;
  final Color color;
  final Color shadowColor;
  final Offset offset;
  final double fontSize;
  final double minFontSize;
  final FontWeight fontWeight;
  final int maxLines;
  final TextDecoration textDecoration;
  final TextAlign textAlign;

  const WTEText({
    super.key,
    required this.text,
    required this.color,
    this.shadowColor = const Color.fromARGB(66, 0, 0, 0),
    this.offset = const Offset(1, 2),
    this.fontSize = 30,
    this.minFontSize = 16,
    this.fontWeight = FontWeight.normal,
    this.maxLines = 1,
    this.textDecoration = TextDecoration.none,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      text,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        shadows: <Shadow>[
          Shadow(
            offset: offset,
            blurRadius: 3,
            color: shadowColor,
          ),
        ],
      ),
      maxLines: maxLines,
      minFontSize: minFontSize,
      overflow: TextOverflow.ellipsis,
    );
  }
}
