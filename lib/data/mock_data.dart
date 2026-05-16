// lib/data/mock_data.dart
// In your mockSessions list, just add arcIndex: N to each SessionModel.
// Arc indices match the palette order:
//   0 = blue-teal  → The Job Hunt
//   1 = green      → Family Boundaries
//   2 = purple     → Moving Out
//   3 = amber      → (any other arc)

// BEFORE (your current code):
//   SessionModel(
//     mood: SessionMood.anxious,
//     dateTime: DateTime(2026, 4, 25, 19, 30),
//     summary: 'Realized the pressure isn\'t about the job...',
//     durationMin: 14,
//     tag: 'THE JOB HUNT',
//   ),

// AFTER (just add arcIndex):
//   SessionModel(
//     arcIndex: 0,            // ← The Job Hunt = blue-teal
//     mood: SessionMood.anxious,
//     dateTime: DateTime(2026, 4, 25, 19, 30),
//     summary: 'Realized the pressure isn\'t about the job...',
//     durationMin: 14,
//     tag: 'THE JOB HUNT',
//   ),

// Full example mock list — replace your existing mockSessions with this:
import 'package:flutter/material.dart';
import '../models/arc_model.dart';
import '../models/session_model.dart';

final List<SessionModel> mockSessions = [
  SessionModel(
    arcIndex: 0,
    mood: SessionMood.anxious,
    dateTime: DateTime(2026, 4, 25, 19, 30),
    summary: 'Realized the pressure isn\'t about the job itself — it\'s about the fear of being seen as not enough.',
    durationMin: 14,
    tag: 'THE JOB HUNT', id: '', arcId: '',
  ),
  SessionModel(
    arcIndex: 0,
    mood: SessionMood.calm,
    dateTime: DateTime(2026, 4, 25, 9, 15),
    summary: 'A brief morning check-in to clear the mind before a big interview. Felt a sense of readiness.',
    durationMin: 5,
    tag: 'THE JOB HUNT', id: '', arcId: '',
  ),
  SessionModel(
    arcIndex: 1,
    mood: SessionMood.frustrated,
    dateTime: DateTime(2026, 4, 24, 20, 0),
    summary: 'Talked through a difficult phone call with mum. Set a boundary and actually held it.',
    durationMin: 18,
    tag: 'FAMILY', id: '', arcId: '',
  ),
  SessionModel(
    arcIndex: 2,
    mood: SessionMood.anxious,
    dateTime: DateTime(2026, 4, 23, 21, 45),
    summary: 'Apartment hunting feels overwhelming. Keeps circling back to whether I\'m ready to be alone.',
    durationMin: 22,
    tag: 'MOVING OUT', id: '', arcId: '',
  ),
  SessionModel(
    arcIndex: 0,
    mood: SessionMood.hopeful,
    dateTime: DateTime(2026, 4, 22, 22, 30),
    summary: 'The waiting game is louder than the interview itself. Noticed how silence triggers self-doubt.',
    durationMin: 11,
    tag: 'THE JOB HUNT', id: '', arcId: '',
  ),
  SessionModel(
    arcIndex: 1,
    mood: SessionMood.sad,
    dateTime: DateTime(2026, 4, 21, 18, 0),
    summary: 'Comparing myself to my sister again. Noticed the pattern — it always starts with a Sunday call.',
    durationMin: 9,
    tag: 'FAMILY', id: '', arcId: '',
  ),
];

final List<ArcModel> mockArcs = [
  ArcModel(
    id: 'arc_0',
    title: 'The Job Hunt',
    sessionCount: 3,
    dotColors: [
      Color(0xFF8B5CF6),
      Color(0xFF10B981),
      Color(0xFFA8E063),
    ],
  ),
  ArcModel(
    id: 'arc_1',
    title: 'Family Boundaries',
    sessionCount: 2,
    dotColors: [
      Color(0xFFF59E0B),
      Color(0xFF3B82F6),
    ],
  ),
  ArcModel(
    id: 'arc_2',
    title: 'Moving Out',
    sessionCount: 1,
    dotColors: [
      Color(0xFF8B5CF6),
    ],
  ),
  ArcModel(
    id: 'arc_3',
    title: 'Old Patterns',
    sessionCount: 4,
    dotColors: [
      Color(0xFF3B82F6),
      Color(0xFF8B5CF6),
      Color(0xFF10B981),
      Color(0xFFF59E0B),
    ],
    isArchived: true,
  ),
];