import 'package:flutter/material.dart';

class ArcAnalysisScreen extends StatelessWidget {
  final String arcId;

  const ArcAnalysisScreen({
    super.key,
    required this.arcId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text(
          'Arc Analysis: $arcId',
        ),
      ),
    );
  }
}
