import 'package:flutter/material.dart';

class ComputerEra {
  final String name;
  final String displayName;
  final Color backgroundColor;
  final Color borderColor;
  final Color screenColor;
  final Color textColor;
  final Color detailColor;
  final double cornerRadius;
  final int requiredCurrency;

  const ComputerEra({
    required this.name,
    required this.displayName,
    required this.backgroundColor,
    required this.borderColor,
    required this.screenColor,
    required this.textColor,
    required this.detailColor,
    required this.cornerRadius,
    required this.requiredCurrency,
  });

  // Define eras
  static const ComputerEra retroEra = ComputerEra(
    name: 'retro',
    displayName: 'Vacuum Tube Era',
    backgroundColor: Color(0xFF6B5B4C),
    borderColor: Color(0xFF4E4234),
    screenColor: Color(0xFF8AFF7B),
    textColor: Color(0xFF005500),
    detailColor: Color(0xFF4E4234),
    cornerRadius: 0,
    requiredCurrency: 0,
  );

  static const ComputerEra transistorEra = ComputerEra(
    name: 'classic',
    displayName: 'Transistor Era',
    backgroundColor: Color(0xFF888888),
    borderColor: Color(0xFF444444),
    screenColor: Color(0xFFB2FFB0),
    textColor: Color(0xFF004400),
    detailColor: Color(0xFF444444),
    cornerRadius: 4,
    requiredCurrency: 1000,
  );

  static const ComputerEra personalEra = ComputerEra(
    name: 'classic',
    displayName: 'Personal Computer Era',
    backgroundColor: Color(0xFFBEBEBE),
    borderColor: Color(0xFF777777),
    screenColor: Color(0xFFCBE8F9),
    textColor: Color(0xFF333333),
    detailColor: Color(0xFFAAAAAA),
    cornerRadius: 8,
    requiredCurrency: 10000,
  );

  static const ComputerEra modernEra = ComputerEra(
    name: 'modern',
    displayName: 'Modern Computing Era',
    backgroundColor: Color(0xFF303030),
    borderColor: Color(0xFF555555),
    screenColor: Color(0xFF000A12),
    textColor: Color(0xFF64FFDA),
    detailColor: Color(0xFF222222),
    cornerRadius: 12,
    requiredCurrency: 100000,
  );

  static const ComputerEra quantumEra = ComputerEra(
    name: 'modern',
    displayName: 'Quantum Computing Era',
    backgroundColor: Color(0xFF1A237E),
    borderColor: Color(0xFF7986CB),
    screenColor: Color(0xFF000A23),
    textColor: Color(0xFF82F7FF),
    detailColor: Color(0xFF3F51B5),
    cornerRadius: 20,
    requiredCurrency: 1000000,
  );

  // Get next era in progression
  ComputerEra? getNextEra() {
    if (this == retroEra) return transistorEra;
    if (this == transistorEra) return personalEra;
    if (this == personalEra) return modernEra;
    if (this == modernEra) return quantumEra;
    return null; // No next era if we're at quantum era
  }
}