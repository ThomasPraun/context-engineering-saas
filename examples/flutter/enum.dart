import 'package:flutter/material.dart';

import 'messages.dart';

/// User status definitions and configurations.
///
/// Defines the different user statuses available in the system
/// with their properties, colors, and display settings.
enum UserStatus { online, offline }

/// Extension methods for UserStatus enum.
extension UserStatusExtension on UserStatus {
  /// Display name for UI
  String get displayName {
    switch (this) {
      case UserStatus.online:
        return AppMessages.disponible;
      case UserStatus.offline:
        return AppMessages.desconectado;
    }
  }
  
  /// Status color
  Color get color {
    switch (this) {
      case UserStatus.online:
        return const Color(0xFF4CAF50); // Green
      case UserStatus.offline:
        return const Color(0xFF9E9E9E); // Grey
    }
  }
  
  /// Status icon
  IconData get icon {
    switch (this) {
      case UserStatus.online:
        return Icons.check_circle;
      case UserStatus.offline:
        return Icons.cancel;
    }
  }
  
  /// Whether the status shows as active
  bool get isActive => this != UserStatus.offline;
}
