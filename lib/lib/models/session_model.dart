class SessionModel {
  final String id;
  final DateTime dateTime;
  final String? tag;
  final String summary;
  final int durationMin;
  final SessionMood mood;
  final String? arcId;

  const SessionModel({
    required this.id,
    required this.dateTime,
    this.tag,
    required this.summary,
    required this.durationMin,
    required this.mood,
    this.arcId,
  });
}

enum SessionMood { calm, reflective, tense, neutral }