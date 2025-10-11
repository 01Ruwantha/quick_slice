import 'package:flutter/material.dart';

class AppBarTitle extends StatefulWidget {
  final String text;
  final double textSize;
  const AppBarTitle({
    super.key,
    required this.text,
    required this.textSize,
  });

  @override
  State<AppBarTitle> createState() => _AppBarTitleState();
}

class _AppBarTitleState extends State<AppBarTitle> {
  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return LinearGradient(
          colors: [
            Color(0xFFF9A825), // A vibrant orange/yellow
            Color(0xFFE65100), // A deeper orange/red
            Color(0xFF880E4F), // A rich deep red/purple
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ).createShader(bounds);
      },
      child: Text(
        widget.text,
        style: TextStyle(
          fontSize: widget.textSize, // Adjusted font size for AppBar
          fontWeight: FontWeight.w900,
          color: Colors.white, // Color is masked by Shader
          fontFamily: 'Roboto', // Consistent font
        ),
      ),
    );
  }
}
