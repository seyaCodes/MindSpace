class EmotionDistribution {
  final int anxious;
  final int calm;
  final int sad;
  final int frustrated;
  final int hopeful;
  final int overwhelmed;

  const EmotionDistribution({
    this.anxious = 0,
    this.calm = 0,
    this.sad = 0,
    this.frustrated = 0,
    this.hopeful = 0,
    this.overwhelmed = 0,
  });

  factory EmotionDistribution.fromJson(Map<String, dynamic> json) =>
      EmotionDistribution(
        anxious: (json['anxious'] as num?)?.toInt() ?? 0,
        calm: (json['calm'] as num?)?.toInt() ?? 0,
        sad: (json['sad'] as num?)?.toInt() ?? 0,
        frustrated: (json['frustrated'] as num?)?.toInt() ?? 0,
        hopeful: (json['hopeful'] as num?)?.toInt() ?? 0,
        overwhelmed: (json['overwhelmed'] as num?)?.toInt() ?? 0,
      );
}
