import 'package:flutter/material.dart';

class MsSkeleton extends StatelessWidget {
  final double width;
  final double height;

  const MsSkeleton({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
