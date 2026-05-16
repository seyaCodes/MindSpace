import 'package:flutter/material.dart';

class ArcModel {
  final String id;
  final String title;
  final int sessionCount;
  final List<Color> dotColors;
  final bool isArchived;

  const ArcModel({
    required this.id,
    required this.title,
    required this.sessionCount,
    required this.dotColors,
    this.isArchived = false,
  });
}
