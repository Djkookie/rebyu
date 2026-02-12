import 'package:flutter/material.dart';

class MyButton extends StatefulWidget {
  final Function()? onTap;
  final String buttonName;

  const MyButton({super.key, required this.onTap, required this.buttonName});

  @override
  MyButtonsState createState() => MyButtonsState();
}

class MyButtonsState extends State<MyButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent.shade200,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: Text(
            widget.buttonName,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
