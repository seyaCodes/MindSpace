import 'package:flutter/material.dart';

enum SpiritType { anxious, calm, frustrated, sad, hopeful, overwhelmed }

class SpiritInfo {
  final String name;
  final Color color;
  final String animationType;
  const SpiritInfo({required this.name, required this.color, required this.animationType});
}

const spiritMap = {
  SpiritType.anxious:     SpiritInfo(name: 'Anxious',     color: Color(0xFF6C5CE7), animationType: 'fastPulse'),
  SpiritType.calm:        SpiritInfo(name: 'Calm',        color: Color(0xFF00C48C), animationType: 'slowBreath'),
  SpiritType.frustrated:  SpiritInfo(name: 'Frustrated',  color: Color(0xFFF39C12), animationType: 'mediumPulse'),
  SpiritType.sad:         SpiritInfo(name: 'Sad',         color: Color(0xFF5B8DEF), animationType: 'slowDrop'),
  SpiritType.hopeful:     SpiritInfo(name: 'Hopeful',     color: Color(0xFFA8E063), animationType: 'rising'),
  SpiritType.overwhelmed: SpiritInfo(name: 'Overwhelmed', color: Color(0xFFE17055), animationType: 'chaotic'),
};

SpiritType spiritFromString(String s) {
  return SpiritType.values.firstWhere(
    (e) => e.name == s.toLowerCase(),
    orElse: () => SpiritType.anxious,
  );
}
