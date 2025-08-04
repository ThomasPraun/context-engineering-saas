import 'messages.dart';

/// Centralized validators for form fields and data validation.
///
/// All validation logic is defined here to maintain consistency
/// and reusability across the application.
class AppValidators {
  // Private constructor to prevent instantiation
  AppValidators._();

  //* REGULAR EXPRESSIONS
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp _numericOnly = RegExp(r'^[0-9]+$');
  static final RegExp _alphanumeric = RegExp(r'^[a-zA-Z0-9]+$');

  //*  COMMON VALIDATORS
  /// Validates that a field is not empty
  static String? required(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName != null ? '$fieldName ' : ''}${AppMessages.requerido}';
    }
    return null;
  }

  /// Validates email format
  static String? email(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!_emailRegex.hasMatch(value.trim())) {
      return AppMessages.invalidEmail;
    }
    return null;
  }

  //*  LENGTH VALIDATORS
  /// Validates minimum length
  static String? minLength(String? value, int min) {
    if (value == null || value.isEmpty) return null;

    if (value.length < min) {
      return '${AppMessages.minChar}: $min';
    }
    return null;
  }

  //*  NUMERIC VALIDATORS
  /// Validates that value is numeric
  static String? numeric(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!_numericOnly.hasMatch(value)) return AppMessages.invalidNumeric;
    return null;
  }

  //*  PASSWORD VALIDATORS
  /// Validates password strength
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return AppMessages.passwordRequired;
    }

    if (value.length < 8) {
      return AppMessages.passwordMinLength;
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return AppMessages.passwordUppercase;
    }

    if (!value.contains(RegExp(r'[a-z]'))) {
      return AppMessages.passwordLowercase;
    }

    if (!value.contains(RegExp(r'[0-9]'))) {
      return AppMessages.passwordNumber;
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return AppMessages.passwordSpecialChar;
    }

    return null;
  }

  //*  CHARACTER TYPE VALIDATORS

  /// Validates alphanumeric characters only
  static String? alphanumeric(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!_alphanumeric.hasMatch(value)) {
      return AppMessages.invalidAlphanumeric;
    }
    return null;
  }

  //*  DATE VALIDATORS

  /// Validates date is not in the future
  static String? notInFuture(DateTime? date) {
    if (date == null) return null;

    if (date.isAfter(DateTime.now())) {
      return AppMessages.invalidDate;
    }
    return null;
  }

  //*  COMPOSITE VALIDATORS
  /// Combines multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  /// Validates with custom condition
  static String? custom(
    String? value,
    bool Function(String) condition,
    String errorMessage,
  ) {
    if (value == null || value.isEmpty) return null;

    if (!condition(value)) {
      return errorMessage;
    }
    return null;
  }
}
