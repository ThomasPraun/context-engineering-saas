/// Centralized storage keys for local data persistence.
/// 
/// All keys used for SharedPreferences, SecureStorage, and database
/// are defined here to avoid key conflicts and maintain consistency.
class StorageKeys {
  // Private constructor to prevent instantiation
  StorageKeys._();
  
  //*  USER PREFERENCES
  static const String themeMode = 'app_theme_mode';
  static const String language = 'app_language';
  static const String firstLaunch = 'app_first_launch';
  
  //*  USER SESSION
  static const String authToken = 'auth_token';
  static const String refreshToken = 'refresh_token';
  
  //*  APP STATE
  static const String lastSyncDate = 'last_sync_date';
  static const String currentVersion = 'current_version';
  static const String lastVersionCheck = 'last_version_check';
  
  //*  CACHE KEYS
  static const String cacheExpiry = 'cache_expiry';
  
  //*  FEATURE FLAGS
  static const String featureNewOnboarding = 'feature_new_onboarding';
  static const String featureDarkMode = 'feature_dark_mode';
  
  //*  SECURITY KEYS (for SecureStorage)
  static const String pinCode = 'secure_pin_code';
  static const String biometricKey = 'secure_biometric_key';
  
  
  //*  NOTIFICATION CHANNELS
  static const String channelGeneral = 'general_notifications';
  static const String channelAlerts = 'alert_notifications';
  
  //*  HELPER METHODS
  /// Generates a unique key for user-specific data
  static String userKey(String userId, String key) {
    return 'user_${userId}_$key';
  }
  
  /// Generates a cache key with timestamp
  static String cacheKey(String key) {
    return 'cache_${key}_${DateTime.now().millisecondsSinceEpoch}';
  }
  
  /// Generates a feature flag key
  static String featureFlag(String feature) {
    return 'feature_$feature';
  }
  
  /// List of all secure keys that should be encrypted
  static List<String> get secureKeys => [
    authToken,
    refreshToken,
    pinCode,
    biometricKey,
  ];
  
  /// List of keys that should be cleared on logout
  static List<String> get sessionKeys => [
    authToken,
    refreshToken,
  ];
}