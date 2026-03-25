import 'package:flutter/material.dart';

class AppColors {
  // Brand — Deep Navy + Electric Blue (BigTech tier)
  static const Color primary = Color(0xFF1A1F6E);
  static const Color primaryMid = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFFEFF6FF);
  static const Color primarySurface = Color(0xFFDBEAFE);

  // Accent
  static const Color accent = Color(0xFFE24B4A);
  static const Color accentLight = Color(0xFFFCEBEB);

  // Semantic
  static const Color success = Color(0xFF15803D);
  static const Color successLight = Color(0xFFF0FDF4);
  static const Color warning = Color(0xFFCA8A04);
  static const Color warningLight = Color(0xFFFEFCE8);

  // Neutrals — Apple-grade gray ramp
  static const Color ink = Color(0xFF0A0B1E); // near-black
  static const Color gray100 = Color(0xFF1C1C1E);
  static const Color gray400 = Color(0xFF48484A);
  static const Color gray500 = Color(0xFF8E8E93);
  static const Color gray600 = Color(0xFFAEAEB2);
  static const Color gray700 = Color(0xFFC7C7CC);
  static const Color gray800 = Color(0xFFF5F5F7); // page background

  // Surfaces
  static const Color background = Color(0xFFF5F5F7);
  static const Color surface = Color(0xFFFFFFFF);

  // Header gradient
  static const LinearGradient headerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A0B1E), Color(0xFF1A1F6E)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1A1F6E), Color(0xFF2563EB)],
  );

  // Legacy aliases (to avoid breaking existing code)
  static const Color redBase = accent;
  static const Color blueBase = primary;
  static const Color blueLight = primaryLight;
}
