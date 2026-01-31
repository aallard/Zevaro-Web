import 'package:flutter/material.dart';

abstract class AppColors {
  // Brand
  static const primary = Color(0xFF3B82F6); // Blue
  static const primaryDark = Color(0xFF1D4ED8);
  static const primaryLight = Color(0xFF93C5FD);

  static const secondary = Color(0xFF8B5CF6); // Purple
  static const secondaryDark = Color(0xFF6D28D9);
  static const secondaryLight = Color(0xFFC4B5FD);

  // Status (matching SDK enums)
  static const success = Color(0xFF10B981); // Green
  static const warning = Color(0xFFF59E0B); // Amber
  static const error = Color(0xFFEF4444); // Red
  static const info = Color(0xFF06B6D4); // Cyan

  // Decision Urgency
  static const urgencyBlocking = Color(0xFFEF4444); // Red
  static const urgencyHigh = Color(0xFFF59E0B); // Amber
  static const urgencyNormal = Color(0xFF3B82F6); // Blue
  static const urgencyLow = Color(0xFF9CA3AF); // Gray

  // Decision Status
  static const statusNeedsInput = Color(0xFFEF4444);
  static const statusUnderDiscussion = Color(0xFFF59E0B);
  static const statusDecided = Color(0xFF10B981);

  // Hypothesis Status
  static const hypothesisDraft = Color(0xFF9CA3AF);
  static const hypothesisReady = Color(0xFF3B82F6);
  static const hypothesisBlocked = Color(0xFFEF4444);
  static const hypothesisBuilding = Color(0xFF8B5CF6);
  static const hypothesisDeployed = Color(0xFFF59E0B);
  static const hypothesisMeasuring = Color(0xFF06B6D4);
  static const hypothesisValidated = Color(0xFF10B981);
  static const hypothesisInvalidated = Color(0xFF6B7280);

  // Neutrals
  static const background = Color(0xFFF9FAFB);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF3F4F6);
  static const border = Color(0xFFE5E7EB);
  static const borderLight = Color(0xFFF3F4F6);

  // Text
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);
  static const textOnPrimary = Color(0xFFFFFFFF);

  // Dark mode variants (for future)
  static const backgroundDark = Color(0xFF111827);
  static const surfaceDark = Color(0xFF1F2937);
  static const textPrimaryDark = Color(0xFFF9FAFB);
}
