import 'package:flutter/material.dart';

class MsTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;

  const MsTextField({super.key, this.hint, this.controller});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
