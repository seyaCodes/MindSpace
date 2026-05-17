import 'package:flutter/material.dart';

class SettingsRow extends StatelessWidget {
  final String label;
  final IconData icon;
  final Widget? trailing;

  const SettingsRow({
    super.key,
    required this.label,
    required this.icon,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
