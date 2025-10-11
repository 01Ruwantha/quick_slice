import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class ExpandableTextInline extends StatefulWidget {
  final String text;
  final int trimLength;
  final double textSize;

  const ExpandableTextInline({
    super.key,
    required this.text,
    this.trimLength = 100,
    required this.textSize,
  });

  @override
  State<ExpandableTextInline> createState() => _ExpandableTextInlineState();
}

class _ExpandableTextInlineState extends State<ExpandableTextInline> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final displayText = isExpanded || widget.text.length <= widget.trimLength
        ? widget.text
        : widget.text.substring(0, widget.trimLength) + '...';

    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 16, color: Colors.black),
        children: [
          TextSpan(
            text: displayText,
            style: TextStyle(
              fontSize: widget.textSize,
            ),
          ),
          if (widget.text.length > widget.trimLength)
            TextSpan(
              text: isExpanded ? '     Show Less' : '     Read More',
              style: TextStyle(
                color: Color(0xFFE65100),
                fontWeight: FontWeight.bold,
                fontSize: widget.textSize,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
            ),
        ],
      ),
    );
  }
}
