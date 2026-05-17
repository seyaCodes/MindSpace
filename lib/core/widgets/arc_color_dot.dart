import 'package:flutter/material.dart';

class ArcColorDot extends StatelessWidget {
  final Color color;
  final double size;

  const ArcColorDot({super.key, required this.color, this.size = 8});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
