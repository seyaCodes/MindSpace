import 'package:flutter/material.dart';
import 'package:mind_space/shared/widgets/app_background.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: const Center(
          child: Text(
            'History',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
