import 'package:flutter/material.dart';

enum MsButtonVariant { primary, secondary, destructive, ghost }

class MsButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final MsButtonVariant variant;
  final Widget? leadingIcon;
  final bool isLoading;

  const MsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = MsButtonVariant.primary,
    this.leadingIcon,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
