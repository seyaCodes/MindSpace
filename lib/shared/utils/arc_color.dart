import 'package:flutter/material.dart';

const _arcPalette = [
  (image: 'assets/purple.png', color: Color(0xFF9B59B6)),
  (image: 'assets/blue.png',   color: Color(0xFF3498DB)),
  (image: 'assets/green.png',  color: Color(0xFF27AE60)),
  (image: 'assets/orange.png', color: Color(0xFFE67E22)),
  (image: 'assets/teal.png',   color: Color(0xFF1ABC9C)),
  (image: 'assets/pink.png',   color: Color(0xFFE91E63)),
];

int _arcIndex(String arcId) {
  final hash = arcId.codeUnits.fold<int>(0, (a, b) => a + b);
  return hash % _arcPalette.length;
}

String arcImageAsset(String arcId) => _arcPalette[_arcIndex(arcId)].image;
Color arcColor(String arcId) => _arcPalette[_arcIndex(arcId)].color;
