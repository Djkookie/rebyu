import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: TextField(
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold
        ),
        controller: controller,
        obscureText: obscureText,
        enableSuggestions: false,
        autocorrect: false,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          enabledBorder:  OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
            borderSide: const BorderSide(
              color: Colors.grey
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          fillColor: Colors.white24,
          filled: true,
          hintStyle:  TextStyle(
            color: Colors.black.withOpacity(0.4),
            fontWeight: FontWeight.bold
          ),
          hintText: hintText,
          contentPadding: const EdgeInsets.all(20),
        ),
      ),
    );
  }
}
