import 'package:flutter/material.dart';

class MsCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const MsCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
