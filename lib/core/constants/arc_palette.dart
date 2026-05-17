import 'package:flutter/material.dart';

class ArcColor {
  final Color color;
  final String assetPath;
  final String label;
  const ArcColor({required this.color, required this.assetPath, required this.label});
}

const arcPalette = [
  ArcColor(color: Color(0xFF8B5CF6), assetPath: 'assets/purple.png',       label: 'purple'),
  ArcColor(color: Color(0xFF26B7CD), assetPath: 'assets/teal.png',         label: 'teal'),
  ArcColor(color: Color(0xFF10B981), assetPath: 'assets/gren.png',         label: 'green'),
  ArcColor(color: Color(0xFFF59E0B), assetPath: 'assets/orrange.png',      label: 'orange'),
  ArcColor(color: Color(0xFF3B82F6), assetPath: 'assets/blue.png',         label: 'blue'),
  ArcColor(color: Color(0xFFEC4899), assetPath: 'assets/pink.png',         label: 'pink'),
];

const arcArchivedAsset = 'assets/purple.png';

ArcColor arcColorByIndex(int i) => arcPalette[i % arcPalette.length];

ArcColor arcColorByHex(String hex) {
  return arcPalette.firstWhere(
    (a) => a.color.value.toRadixString(16).toUpperCase().contains(hex.toUpperCase().replaceAll('#', '')),
    orElse: () => arcPalette[0],
  );
}
