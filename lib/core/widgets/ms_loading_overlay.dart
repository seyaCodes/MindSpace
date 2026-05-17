import 'package:flutter/material.dart';

class MsLoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const MsLoadingOverlay({super.key, required this.isLoading, required this.child});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
