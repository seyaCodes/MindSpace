import 'package:flutter/material.dart';

class QuickReplyChips extends StatelessWidget {
  final void Function(String) onSelected;

  const QuickReplyChips({super.key, required this.onSelected});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
