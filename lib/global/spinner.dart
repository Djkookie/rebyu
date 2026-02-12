import 'package:flutter/material.dart';

class Spinner extends StatefulWidget {
  final IconData icon;
  final Duration duration;

  const Spinner({
    super.key,
    required this.icon,
    this.duration = const Duration(milliseconds: 1800),
  });

  @override
  SpinnerState createState() => SpinnerState();
}

class SpinnerState extends State<Spinner> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Widget _child;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    _child = Icon(
      widget.icon,
      color:  Colors.deepPurple.shade300,
      size: 28,
    );

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: _child,
    );
  }
}