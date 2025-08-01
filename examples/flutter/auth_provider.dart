import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './api_service.dart';
import './user_model.dart';

/// Authentication state enum
enum AuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
  error,
}

/// Example Authentication Provider using ChangeNotifier
/// This pattern demonstrates state management, error handling, and persistence
class AuthProvider extends ChangeNotifier {
  final ApiService _apiService;
  final SharedPreferences _prefs;

  // State variables
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;
  
  // Public getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _status == AuthStatus.authenticated;
  bool get isLoading => _status == AuthStatus.loading;

  AuthProvider({
    required ApiService apiService,
    required SharedPreferences prefs,
  })  : _apiService = apiService,
        _prefs = prefs {
    _initializeAuth();
  }

  /// Initialize authentication state from storage
  Future<void> _initializeAuth() async {
    _setStatus(AuthStatus.loading);
    
    try {
      // Check for stored auth token
      final token = _prefs.getString('auth_token');
      if (token == null) {
        _setStatus(AuthStatus.unauthenticated);
        return;
      }

      // Validate token by fetching user profile
      await fetchCurrentUser();
    } catch (e) {
      // Token invalid or expired
      await signOut();
    }
  }

  /// Sign in with email and password
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _setStatus(AuthStatus.loading);
    _clearError();

    try {
      // Call login API
      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      // Extract tokens and user data
      final accessToken = response['accessToken'] as String;
      final refreshToken = response['refreshToken'] as String;
      final userData = response['user'] as Map<String, dynamic>;

      // Store tokens
      await _prefs.setString('auth_token', accessToken);
      await _prefs.setString('refresh_token', refreshToken);

      // Parse and store user
      _user = User.fromJson(userData);
      _setStatus(AuthStatus.authenticated);

      // Store user data for offline access
      await _prefs.setString('cached_user', _user!.toJsonString());
    } on AppException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      _handleAuthError(
        AppException(
          message: 'Failed to sign in. Please try again.',
          code: 'SIGNIN_FAILED',
        ),
      );
    }
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    _setStatus(AuthStatus.loading);
    _clearError();

    try {
      // Call registration API
      final response = await _apiService.post<Map<String, dynamic>>(
        '/auth/register',
        data: {
          'email': email,
          'password': password,
          'name': name,
        },
      );

      // Extract tokens and user data
      final accessToken = response['accessToken'] as String;
      final refreshToken = response['refreshToken'] as String;
      final userData = response['user'] as Map<String, dynamic>;

      // Store tokens
      await _prefs.setString('auth_token', accessToken);
      await _prefs.setString('refresh_token', refreshToken);

      // Parse and store user
      _user = User.fromJson(userData);
      _setStatus(AuthStatus.authenticated);

      // Store user data for offline access
      await _prefs.setString('cached_user', _user!.toJsonString());
    } on AppException catch (e) {
      _handleAuthError(e);
    } catch (e) {
      _handleAuthError(
        AppException(
          message: 'Failed to create account. Please try again.',
          code: 'SIGNUP_FAILED',
        ),
      );
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    _setStatus(AuthStatus.loading);
    
    try {
      // Call logout API to invalidate token on server
      await _apiService.post('/auth/logout');
    } catch (e) {
      // Continue with local logout even if API call fails
      if (kDebugMode) {
        print('Logout API call failed: $e');
      }
    }

    // Clear local storage
    await _prefs.remove('auth_token');
    await _prefs.remove('refresh_token');
    await _prefs.remove('cached_user');

    // Clear state
    _user = null;
    _clearError();
    _setStatus(AuthStatus.unauthenticated);
  }

  /// Fetch current user profile
  Future<void> fetchCurrentUser() async {
    try {
      final userData = await _apiService.get<Map<String, dynamic>>(
        '/auth/me',
      );

      _user = User.fromJson(userData);
      _setStatus(AuthStatus.authenticated);

      // Update cached user data
      await _prefs.setString('cached_user', _user!.toJsonString());
    } on AppException catch (e) {
      // Try to load cached user data for offline access
      final cachedUserJson = _prefs.getString('cached_user');
      if (cachedUserJson != null) {
        try {
          _user = User.fromJsonString(cachedUserJson);
          _setStatus(AuthStatus.authenticated);
          return;
        } catch (_) {
          // Cached data is invalid
        }
      }
      
      _handleAuthError(e);
    }
  }

  /// Update user profile
  Future<void> updateProfile({
    String? name,
    String? avatarUrl,
  }) async {
    if (_user == null) return;

    _setStatus(AuthStatus.loading);
    _clearError();

    try {
      final userData = await _apiService.put<Map<String, dynamic>>(
        '/users/${_user!.id}',
        data: {
          if (name != null) 'name': name,
          if (avatarUrl != null) 'avatarUrl': avatarUrl,
        },
      );

      _user = User.fromJson(userData);
      _setStatus(AuthStatus.authenticated);

      // Update cached user data
      await _prefs.setString('cached_user', _user!.toJsonString());
    } on AppException catch (e) {
      _handleAuthError(e);
    }
  }

  /// Request password reset
  Future<void> requestPasswordReset(String email) async {
    _setStatus(AuthStatus.loading);
    _clearError();

    try {
      await _apiService.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
      
      _setStatus(AuthStatus.unauthenticated);
      // Note: In a real app, you'd show a success message
    } on AppException catch (e) {
      _handleAuthError(e);
    }
  }

  /// Verify email with OTP
  Future<void> verifyEmail(String otp) async {
    if (_user == null) return;

    _setStatus(AuthStatus.loading);
    _clearError();

    try {
      final userData = await _apiService.post<Map<String, dynamic>>(
        '/auth/verify-email',
        data: {'otp': otp},
      );

      _user = User.fromJson(userData);
      _setStatus(AuthStatus.authenticated);

      // Update cached user data
      await _prefs.setString('cached_user', _user!.toJsonString());
    } on AppException catch (e) {
      _handleAuthError(e);
    }
  }

  /// Delete user account
  Future<void> deleteAccount() async {
    if (_user == null) return;

    _setStatus(AuthStatus.loading);
    _clearError();

    try {
      await _apiService.delete('/users/${_user!.id}');
      await signOut();
    } on AppException catch (e) {
      _handleAuthError(e);
    }
  }

  /// Check if user has a specific permission
  bool hasPermission(String permission) {
    return _user?.permissions.contains(permission) ?? false;
  }

  /// Check if user has a specific role
  bool hasRole(String role) {
    return _user?.roles.contains(role) ?? false;
  }

  /// Private helper methods
  void _setStatus(AuthStatus status) {
    _status = status;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  void _handleAuthError(AppException error) {
    _errorMessage = error.message;
    
    if (error.code == 'UNAUTHORIZED' || error.code == 'TOKEN_EXPIRED') {
      _user = null;
      _setStatus(AuthStatus.unauthenticated);
    } else {
      _setStatus(AuthStatus.error);
    }
  }

  @override
  void dispose() {
    // Clean up any resources if needed
    super.dispose();
  }
}