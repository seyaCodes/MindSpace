import 'package:flutter/material.dart';

class WrapUpPill extends StatelessWidget {
  final VoidCallback onTap;

  const WrapUpPill({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
