import 'package:flutter/material.dart';

import '../widgets/analysis_header.dart';
import '../widgets/analysis_stats_row.dart';
import '../widgets/arc_analysis_section.dart';
import '../widgets/reflection_heatmap_card.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E1547),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 130),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnalysisHeader(),
              SizedBox(height: 24),
              AnalysisStatsRow(),
              SizedBox(height: 24),
              ReflectionHeatmapCard(),
              SizedBox(height: 32),
              ArcAnalysisSection(),
            ],
          ),
        ),
      ),
    );
  }
}
