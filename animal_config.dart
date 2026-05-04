import 'package:flutter/material.dart';

enum AnimalType {
  fox,
  cat,
  owl,
  axolotl,
  rabbit,
  panda,
}

class AnimalConfig {
  final AnimalType type;
  final String name;
  final String emoji;
  final Color primaryColor;
  final Color accentColor;
  final Color furColor;
  final Color eyeColor;
  final String personality;
  final String greeting;

  const AnimalConfig({
    required this.type,
    required this.name,
    required this.emoji,
    required this.primaryColor,
    required this.accentColor,
    required this.furColor,
    required this.eyeColor,
    required this.personality,
    required this.greeting,
  });

  static const List<AnimalConfig> all = [
    AnimalConfig(
      type: AnimalType.fox,
      name: 'Fox',
      emoji: '🦊',
      primaryColor: Color(0xFFFF6B35),
      accentColor: Color(0xFFFFD166),
      furColor: Color(0xFFE8773A),
      eyeColor: Color(0xFF2D9B5A),
      personality: 'Clever & Curious',
      greeting: 'Hey there! Ready to outsmart the day? 🦊',
    ),
    AnimalConfig(
      type: AnimalType.cat,
      name: 'Cat',
      emoji: '🐱',
      primaryColor: Color(0xFF9B89CC),
      accentColor: Color(0xFFFFB3C6),
      furColor: Color(0xFFB8A9D9),
      eyeColor: Color(0xFF4ECDC4),
      personality: 'Elegant & Witty',
      greeting: 'Greetings, human. I suppose I can help you. 🐱',
    ),
    AnimalConfig(
      type: AnimalType.owl,
      name: 'Owl',
      emoji: '🦉',
      primaryColor: Color(0xFF6B7A8D),
      accentColor: Color(0xFFFFD700),
      furColor: Color(0xFF8B9BAC),
      eyeColor: Color(0xFFFFAA00),
      personality: 'Wise & Patient',
      greeting: 'Wisdom awaits. What shall we explore today? 🦉',
    ),
    AnimalConfig(
      type: AnimalType.axolotl,
      name: 'Axolotl',
      emoji: '🦎',
      primaryColor: Color(0xFFFF9EBC),
      accentColor: Color(0xFF7DF9C4),
      furColor: Color(0xFFFFB8D1),
      eyeColor: Color(0xFF6366F1),
      personality: 'Playful & Regenerative',
      greeting: 'Hii!! Lets do something amazing together!! 🌸',
    ),
    AnimalConfig(
      type: AnimalType.rabbit,
      name: 'Rabbit',
      emoji: '🐰',
      primaryColor: Color(0xFFF8E1E1),
      accentColor: Color(0xFFFF8FAB),
      furColor: Color(0xFFF0D0D0),
      eyeColor: Color(0xFFE91E8C),
      personality: 'Swift & Energetic',
      greeting: 'Zoom zoom! So much to do, lets go! 🐰',
    ),
    AnimalConfig(
      type: AnimalType.panda,
      name: 'Panda',
      emoji: '🐼',
      primaryColor: Color(0xFFE8E8E8),
      accentColor: Color(0xFF2D2D2D),
      furColor: Color(0xFFF5F5F5),
      eyeColor: Color(0xFF1A1A2E),
      personality: 'Calm & Thoughtful',
      greeting: 'Hello friend. Let us think this through together. 🐼',
    ),
  ];
}
