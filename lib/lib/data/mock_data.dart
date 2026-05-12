import 'package:flutter/material.dart';
import '../models/session_model.dart';
import '../models/arc_model.dart';

final mockSessions = [
  SessionModel(
    id: '1',
    dateTime: DateTime(2026, 4, 22, 19, 30),
    tag: 'THE JOB HUNT',
    summary: 'Focused on internal vs external validation regarding the upcoming interview.',
    durationMin: 12,
    mood: SessionMood.reflective,
    arcId: 'arc1',
  ),
  SessionModel(
    id: '2',
    dateTime: DateTime(2026, 4, 22, 9, 15),
    summary: 'A brief morning check-in to clear the mind before work.',
    durationMin: 5,
    mood: SessionMood.calm,
  ),
  SessionModel(
    id: '3',
    dateTime: DateTime(2026, 4, 19, 20, 0),
    tag: 'FAMILY BOUNDARIES',
    summary: 'A quieter session about finding small moments of peace after a long call.',
    durationMin: 18,
    mood: SessionMood.neutral,
    arcId: 'arc2',
  ),
  SessionModel(
    id: '4',
    dateTime: DateTime(2026, 3, 28, 22, 30),
    tag: 'HEALTH ROUTINE',
    summary: 'Addressed the recurring pattern of saying yes when meaning no.',
    durationMin: 15,
    mood: SessionMood.tense,
    arcId: 'arc3',
  ),
];

final mockArcs = [
  ArcModel(
    id: 'arc1',
    title: 'The Job Hunt',
    sessionCount: 5,
    dotColors: [Color(0xFF8B5CF6), Color(0xFFEF4444), Color(0xFFFBBF24), Color(0xFF10B981)],
  ),
  ArcModel(
    id: 'arc2',
    title: 'Family Boundaries',
    sessionCount: 3,
    dotColors: [Color(0xFF8B5CF6), Color(0xFF3B82F6), Color(0xFF10B981)],
  ),
  ArcModel(
    id: 'arc3',
    title: 'Health Routine',
    sessionCount: 2,
    dotColors: [Color(0xFFFBBF24), Color(0xFF10B981)],
  ),
];