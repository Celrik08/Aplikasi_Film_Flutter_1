import 'package:flutter/material.dart';

class TruncatedText extends StatelessWidget {
  final String text;
  final int maxLength;
  final TextStyle style;
  final VoidCallback onTap;

  TruncatedText({
    required this.text,
    required this.maxLength,
    required this.style,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text.length > maxLength ? '${text.substring(0, maxLength)}...' : text,
        style: style,
      ),
    );
  }
}
