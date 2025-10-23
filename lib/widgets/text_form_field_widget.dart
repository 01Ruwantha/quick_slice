import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  const TextFormFieldWidget({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,

        hintStyle: TextStyle(color: Colors.grey),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      validator: (value) {
        if (hintText == 'Code' && value!.isNotEmpty) {
          if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
            return 'Phone number must contain only digits';
          }
          if (!value.startsWith('0')) {
            return 'Phone number must start with 0';
          }
          if (value.length != 10) {
            return 'Please enter a 10-digit phone number';
          }
        }
        if (hintText == 'Password') {
          if (value!.isEmpty) {
            return "Plese enter $hintText";
          }
          if (value.length < 6) {
            return 'Password is too short';
          }
        }
        if (hintText == 'Email') {
          final emailRegex = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
          );
          if (!emailRegex.hasMatch(value.toString())) {
            return 'Enter a valid email address';
          }
        }
        if (value == null || value.isEmpty) {
          return "Plese enter $hintText";
        }
        return null;
      },
    );
  }
}
