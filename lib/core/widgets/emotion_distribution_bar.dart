import 'package:flutter/material.dart';

class EmotionDistributionBar extends StatelessWidget {
  final Map<String, int> distribution;

  const EmotionDistributionBar({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
