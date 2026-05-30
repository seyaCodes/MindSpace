import 'package:flutter/material.dart';

class ReflectionHeatmapCard extends StatelessWidget {
  const ReflectionHeatmapCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.05),
        borderRadius: BorderRadius.circular(28),
      ),
      child: const Center(
        child: Text(
          'Heatmap Placeholder',
        ),
      ),
    );
  }
}
