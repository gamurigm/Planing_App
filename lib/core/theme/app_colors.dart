import 'package:flutter/material.dart';

/// Central color palette for PlanifApp to avoid hard-coded blues spread.
class AppColors {
  static const Color primary = Color(0xFF1E88E5); // moderate blue
  // Reverted to blue tones per user preference
  static const Color header = Color(
    0xFF2E95E6,
  ); // moderate blue (same as primary)
  static const Color subjectTitle = Color(
    0xFF1565C0,
  ); // darker blue for sidebar titles
  // User requested turquoise: update header/subjectTitle to turquoise tones
  // Turquoise hex approximations
  // header: #40E0D0 -> 0xFF40E0D0
  // subjectTitle: #008B8B -> 0xFF008B8B

  static const Color activityLabelBg = Color(0xFFF3F6F7); // very light gray
  static const Color cellDefault = Colors.white;
  // darker blue border for clearer division
  static const Color cellBorder = Color(0xFF0B3D91); // very dark blue
  static const Color accent = Color(0xFF6C5CE7); // purple accent for projects
  // Turquoise overlays for hover/press (light, semi-transparent)
  static const Color turquoiseLight = Color(0x3340E0D0); // 20% opacity turquoise
  static const Color turquoisePressed = Color(0x5538CFC9); // ~33% opacity slightly darker turquoise
  // Neon colors for border highlights
  static const Color neonTurquoise = Color(0xFF00FFD1);
  static const Color neonTurquoiseShadow = Color(0x3333FFD6); // lighter semi-transparent neon for subtle glow
  // Strip background: use the same color as the header (slightly lighter primary)
  static const Color stripBg = header;
  // Subtle grid color for both horizontal and vertical grid lines
  static const Color subtleGrid = Color(0xFFBDBDBD);
  // Vertical divider (kept for very strong separators if needed)
  static const Color verticalDivider = Color(0xFF000000);
}
