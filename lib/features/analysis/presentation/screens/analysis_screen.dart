import 'package:flutter/material.dart';

import '../widgets/analysis_header.dart';
import '../widgets/analysis_stats_row.dart';
import '../widgets/reflection_heatmap_card.dart';
import '../widgets/arc_analysis_section.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 130),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnalysisHeader(),
              SizedBox(height: 28),
              AnalysisStatsRow(),
              SizedBox(height: 28),
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
