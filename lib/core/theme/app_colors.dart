import 'package:flutter/material.dart';

class AppColors {
  // ===== PRIMARY (Soft Mint Theme) =====
  static const Color softMint = Color.fromARGB(255, 159, 247, 201);
  static const Color mintGreen = Color(0xFF10B981);
  static const Color deepGreen = Color(0xFF047857);

  // ===== BACKGROUND =====
  static const Color lightMint = Color.fromARGB(255, 124, 242, 187);
  static const Color white = Color(0xFFFFFFFF);

  // ===== TEXT =====
  static const Color darkGray = Color(0xFF374151);
  static const Color gray = Color(0xFF6B7280);
  
  // ===== STATES =====
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);

  // ===== BORDER / DIVIDER =====
  static const Color border = Color.fromARGB(255, 0, 0, 0);

  // =====================================================
  // CALENDAR
  // =====================================================

  /// Header
  static const Color calendarHeaderText = deepGreen;
  static const Color calendarHeaderIcon = deepGreen;

  /// Week Header (CN, T2...)
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
  static const Color calendarDayBorder = Color.fromARGB(255, 0, 0, 0);

  /// Shadow
  static const Color calendarShadow = Color(0x14000000);

  ////acitivity status
  static const Color completed = Color.fromARGB(255, 0, 97, 254);
  static const Color cancelled = Color.fromARGB(255, 255, 17, 0);
  static const Color pending = Color.fromARGB(255, 227, 170, 14);
  static const Color accepted = Color.fromARGB(255, 15, 251, 55);
  

}