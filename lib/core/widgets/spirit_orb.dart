import 'package:flutter/material.dart';

class SpiritOrb extends StatelessWidget {
  final Color color;
  final double size;

  const SpiritOrb({super.key, required this.color, this.size = 80});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
