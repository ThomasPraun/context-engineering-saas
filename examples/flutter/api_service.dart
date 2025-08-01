import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Example API Service with authentication, error handling, and interceptors
/// This pattern should be followed for all API integrations
class ApiService {
  static const String _baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api/v1',
  );

  late final Dio _dio;
  final SharedPreferences _prefs;

  ApiService(this._prefs) {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Request interceptor for authentication
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add auth token to requests
          final token = _prefs.getString('auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          // Log request in debug mode
          if (kDebugMode) {
            print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
            print('📋 Headers: ${options.headers}');
            print('📦 Data: ${options.data}');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Log response in debug mode
          if (kDebugMode) {
            print('✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
            print('📦 Data: ${response.data}');
          }

          return handler.next(response);
        },
        onError: (error, handler) async {
          // Handle different error scenarios
          if (error.response?.statusCode == 401) {
            // Token expired, try to refresh
            final refreshed = await _refreshToken();
            if (refreshed) {
              // Retry the request with new token
              final opts = error.requestOptions;
              final token = _prefs.getString('auth_token');
              opts.headers['Authorization'] = 'Bearer $token';
              
              try {
                final response = await _dio.request(
                  opts.path,
                  options: Options(
                    method: opts.method,
                    headers: opts.headers,
                  ),
                  data: opts.data,
                  queryParameters: opts.queryParameters,
                );
                return handler.resolve(response);
              } catch (e) {
                return handler.reject(error);
              }
            }
          }

          // Log error in debug mode
          if (kDebugMode) {
            print('❌ ERROR[${error.response?.statusCode}] => PATH: ${error.requestOptions.path}');
            print('📦 Message: ${error.message}');
            print('📦 Data: ${error.response?.data}');
          }

          return handler.next(error);
        },
      ),
    );
  }

  /// Refresh the authentication token
  Future<bool> _refreshToken() async {
    try {
      final refreshToken = _prefs.getString('refresh_token');
      if (refreshToken == null) return false;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        await _prefs.setString('auth_token', data['accessToken']);
        await _prefs.setString('refresh_token', data['refreshToken']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Generic GET request
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      
      final data = response.data['data'];
      return parser != null ? parser(data) : data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic POST request
  Future<T> post<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      
      final responseData = response.data['data'];
      return parser != null ? parser(responseData) : responseData as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic PUT request
  Future<T> put<T>(
    String path, {
    dynamic data,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.put(path, data: data);
      
      final responseData = response.data['data'];
      return parser != null ? parser(responseData) : responseData as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic DELETE request
  Future<void> delete(String path) async {
    try {
      await _dio.delete(path);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Upload file with progress tracking
  Future<T> uploadFile<T>(
    String path,
    String filePath, {
    Map<String, dynamic>? additionalData,
    void Function(double)? onProgress,
    T Function(dynamic)? parser,
  }) async {
    try {
      final formData = FormData();
      
      // Add file
      formData.files.add(
        MapEntry(
          'file',
          await MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          ),
        ),
      );
      
      // Add additional data
      additionalData?.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });

      final response = await _dio.post(
        path,
        data: formData,
        onSendProgress: (sent, total) {
          if (onProgress != null && total > 0) {
            onProgress(sent / total);
          }
        },
      );

      final data = response.data['data'];
      return parser != null ? parser(data) : data as T;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Handle and transform API errors
  AppException _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException(
          message: 'Connection timeout. Please check your internet connection.',
          code: 'TIMEOUT',
        );
      
      case DioExceptionType.connectionError:
        return AppException(
          message: 'Unable to connect to server. Please check your internet connection.',
          code: 'CONNECTION_ERROR',
        );
      
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;
        final data = error.response?.data;
        final message = data is Map ? data['error']?['message'] : null;
        
        switch (statusCode) {
          case 400:
            return AppException(
              message: message ?? 'Invalid request',
              code: 'BAD_REQUEST',
              errors: data is Map ? data['error']?['errors'] : null,
            );
          case 401:
            return AppException(
              message: message ?? 'Authentication failed',
              code: 'UNAUTHORIZED',
            );
          case 403:
            return AppException(
              message: message ?? 'Access denied',
              code: 'FORBIDDEN',
            );
          case 404:
            return AppException(
              message: message ?? 'Resource not found',
              code: 'NOT_FOUND',
            );
          case 422:
            return AppException(
              message: message ?? 'Validation failed',
              code: 'VALIDATION_ERROR',
              errors: data is Map ? data['error']?['errors'] : null,
            );
          case 500:
            return AppException(
              message: message ?? 'Server error occurred',
              code: 'SERVER_ERROR',
            );
          default:
            return AppException(
              message: message ?? 'An error occurred',
              code: 'UNKNOWN_ERROR',
            );
        }
      
      default:
        return AppException(
          message: 'An unexpected error occurred',
          code: 'UNEXPECTED_ERROR',
        );
    }
  }
}

/// Custom exception class for consistent error handling
class AppException implements Exception {
  final String message;
  final String code;
  final Map<String, dynamic>? errors;

  AppException({
    required this.message,
    required this.code,
    this.errors,
  });

  @override
  String toString() => message;
}