import 'package:flutter/material.dart';

class AppColors {
  // =====================================================
  // PRIMARY
  // =====================================================

  static const Color primary = Color(0xFF4CAF7D);
  static const Color primaryLight = Color(0xFF8EE4B5);
  static const Color primaryDark = Color(0xFF2F8F62);

  // Giữ tương thích với code cũ
  static const Color softMint = primaryLight;
  static const Color mintGreen = primary;
  static const Color deepGreen = primaryDark;

  // =====================================================
  // BACKGROUND
  // =====================================================

  static const Color scaffoldBackground = Color(0xFFF8FFFC);
  static const Color lightMint = Color(0xFFEEFDF5);
  static const Color white = Color(0xFFFFFFFF);

  static const LinearGradient backgroundGradient = LinearGradient(
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
  colors: [
    Color(0xFF7FE7B2),
    Color(0xFFB8F3D5),
    Color.fromARGB(255, 220, 239, 253),
    Color(0xFFB8F3D5),
    Color(0xFF7FE7B2),
  ],
);

  static const LinearGradient appBarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF4CAF7D),
      Color(0xFF10B981),
    ],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF34D399),
      Color(0xFF10B981),
    ],
  );

  // =====================================================
  // CARD
  // =====================================================

  static const Color cardBackground = Colors.white;
  static const Color dialogBackground = Colors.white;

  // =====================================================
  // TEXT
  // =====================================================

  static const Color titleText = Color(0xFF1F2937);
  static const Color darkGray = Color(0xFF374151);
  static const Color gray = Color(0xFF6B7280);
  static const Color subtitleText = gray;
  static const Color hintText = Color(0xFF9CA3AF);
  static const Color disabledText = Color(0xFFD1D5DB);

  // =====================================================
  // ICON
  // =====================================================

  static const Color iconPrimary = primary;
  static const Color iconSecondary = gray;

  // =====================================================
  // STATUS
  // =====================================================

  static const Color success = Color(0xFF22C55E);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // =====================================================
  // APPOINTMENT STATUS
  // =====================================================

  static const Color completed = Color(0xFF3B82F6);
  static const Color cancelled = Color(0xFFEF4444);
  static const Color pending = Color(0xFFF59E0B);
  static const Color accepted = Color(0xFF22C55E);

  // =====================================================
  // NOTIFICATION
  // =====================================================

  static const Color notificationUnread = Color(0xFFEEFDF5);
  static const Color notificationRead = Colors.white;
  static const Color notificationBadge = Color(0xFFEF4444);

  // =====================================================
  // RATING
  // =====================================================

  static const Color star = Color(0xFFFACC15);
  static const Color emptyStar = Color(0xFFD1D5DB);

  // =====================================================
  // BORDER
  // =====================================================

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFE5E7EB);

  // =====================================================
  // SHADOW
  // =====================================================

  static const Color shadow = Color(0x14000000);

  // =====================================================
  // ACCENT
  // =====================================================

  static const Color blueAccent = Color(0xFF60A5FA);
  static const Color purpleAccent = Color(0xFFA78BFA);
  static const Color coralAccent = Color(0xFFFB7185);
  static const Color orangeAccent = Color(0xFFFB923C);

  // =====================================================
  // CALENDAR
  // =====================================================

  /// Header
  static const Color calendarHeaderText = deepGreen;
  static const Color calendarHeaderIcon = deepGreen;

  /// Week Header
  static const Color calendarWeekText = gray;

  /// Default Day
  static const Color calendarDayBackground = white;
  static const Color calendarDayText = darkGray;

  /// Today
  static const Color calendarTodayBackground = softMint;
  static const Color calendarTodayBorder = mintGreen;
  static const Color calendarTodayText = deepGreen;

  /// Selected Day
  static const Color calendarSelectedBackground = mintGreen;
  static const Color calendarSelectedText = white;

  /// Booked Day
  static const Color calendarBookedBackground = Color(0xFFFFF7ED);
  static const Color calendarBookingDot = warning;

  /// Border
  static const Color calendarDayBorder = border;

  /// Shadow
  static const Color calendarShadow = shadow;
}