import 'package:flutter/material.dart';
import 'package:mind_space/shared/widgets/app_background.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: const Center(
          child: Text(
            'Settings',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
