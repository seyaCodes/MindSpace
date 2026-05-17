import 'package:flutter/material.dart';

class ReflectionSection extends StatelessWidget {
  final String label;
  final String content;

  const ReflectionSection({super.key, required this.label, required this.content});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
