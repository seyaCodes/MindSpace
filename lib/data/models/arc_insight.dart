class ArcInsight {
  final String id;
  final String arcId;
  final String userId;
  final String? leadParagraph;
  final String? howItEvolved;
  final String? patternNoticed;
  final String? turningPoint;
  final String? userNote;
  final int sessionCountAtGeneration;
  final DateTime generatedAt;

  const ArcInsight({
    required this.id,
    required this.arcId,
    required this.userId,
    this.leadParagraph,
    this.howItEvolved,
    this.patternNoticed,
    this.turningPoint,
    this.userNote,
    required this.sessionCountAtGeneration,
    required this.generatedAt,
  });
}
