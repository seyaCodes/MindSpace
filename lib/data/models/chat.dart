// lib/data/models/chat.dart
// Replace your entire existing file with this.
// Only change from your original: added `arcIndex` field everywhere it needs to be.

enum SessionMood { anxious, calm, sad, frustrated, hopeful, overwhelmed }

class SessionModel {
  final SessionMood mood;
  final DateTime dateTime;
  final String summary;
  final int durationMin;
  final String? tag;
  final int arcIndex; // ← NEW: which arc this session belongs to (0,1,2...)

  const SessionModel({
    required this.mood,
    required this.dateTime,
    required this.summary,
    required this.durationMin,
    this.tag,
    this.arcIndex = 0, required String id, required String arcId, // defaults to 0 (blue-teal) if not set
  });
}
