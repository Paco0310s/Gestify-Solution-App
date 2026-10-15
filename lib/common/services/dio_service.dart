import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gestify_solution/common/constants/app_config.dart';
import 'package:gestify_solution/common/constants/app_texts.dart';
import 'package:gestify_solution/common/errors/http_failure.dart';
import 'package:gestify_solution/common/logging/app_logger.dart';
import 'package:gestify_solution/common/services/storage_service.dart';
import 'package:gestify_solution/common/utils/either.dart';

class DioService {
  static bool _isRefreshing = false;

  /// Attempts to obtain a new access token using the stored refresh token.
  static Future<bool> tryRefreshToken() async {
    if (_isRefreshing) return false;
    _isRefreshing = true;

    try {
      final refreshToken = StorageService.getString(AppConfig.refreshTokenKey);
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final refreshDio = Dio(
        BaseOptions(
          baseUrl: AppConfig.baseUrl,
          connectTimeout: AppConfig.connectTimeout,
          receiveTimeout: AppConfig.receiveTimeout,
        ),
      );

      final response = await refreshDio.post(
        AppConfig.refreshTokenEndpoint,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final newAccessToken = data['access_token'] ?? data['accessToken'];
          final newRefreshToken = data['refresh_token'] ?? data['refreshToken'];

          if (newAccessToken != null) {
            StorageService.setString(AppConfig.accessTokenKey, newAccessToken.toString());
          }
          if (newRefreshToken != null) {
            StorageService.setString(AppConfig.refreshTokenKey, newRefreshToken.toString());
          }
          AppLogger.info('Access token refreshed successfully');
          return true;
        }
      }
    } catch (e) {
      AppLogger.warning('Token refresh failed: $e');
    } finally {
      _isRefreshing = false;
    }
    return false;
  }

  static final Dio _dio =
      Dio(
          BaseOptions(
            baseUrl: AppConfig.baseUrl,
            connectTimeout: AppConfig.connectTimeout,
            receiveTimeout: AppConfig.receiveTimeout,
            sendTimeout: AppConfig.sendTimeout,
          ),
        )
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              final isPublicEndpoint = AppConfig.publicEndpoints.any((endpoint) => options.path.contains(endpoint));

              if (!isPublicEndpoint) {
                final token = StorageService.getString(AppConfig.accessTokenKey);
                if (token != null) {
                  options.headers['Authorization'] = 'Bearer $token';
                }
              }
              return handler.next(options);
            },
            onError: (error, handler) async {
              if (error.response?.statusCode == 401) {
                final requestPath = error.requestOptions.path;
                final isAuthEndpoint = AppConfig.publicEndpoints.any((endpoint) => requestPath.contains(endpoint));

                if (!isAuthEndpoint) {
                  final refreshed = await tryRefreshToken();
                  if (refreshed) {
                    final newAccessToken = StorageService.getString(AppConfig.accessTokenKey);
                    if (newAccessToken != null && error.requestOptions.data is! FormData) {
                      error.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                      try {
                        final retryResponse = await _dio.fetch(error.requestOptions);
                        return handler.resolve(retryResponse);
                      } catch (retryError) {
                        AppLogger.error('Request retry failed: $retryError');
                      }
                    }
                  }
                }
              }
              return handler.next(error);
            },
          ),
        );

  // Método privado para manejar errores
  static EitherUtil<HttpFailure, T> _handleError<T>(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        AppLogger.warning('Connection timeout: ${error.message}', error: error, stackTrace: error.stackTrace);
        return EitherUtil.failure(HttpFailure.connectionTimeout());

      case DioExceptionType.sendTimeout:
        AppLogger.warning('Send timeout: ${error.message}', error: error, stackTrace: error.stackTrace);
        return EitherUtil.failure(HttpFailure.sendTimeout());

      case DioExceptionType.receiveTimeout:
        AppLogger.warning('Receive timeout: ${error.message}', error: error, stackTrace: error.stackTrace);
        return EitherUtil.failure(HttpFailure.receiveTimeout());

      case DioExceptionType.connectionError:
        AppLogger.warning('Connection error: ${error.message}', error: error, stackTrace: error.stackTrace);
        return EitherUtil.failure(HttpFailure.connectionError());

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 0;

        String message = '';
        String defaultMessage = statusCode == 401
            ? 'Tu sesión ha expirado o no tienes autorización. Por favor inicia sesión nuevamente.'
            : '${AppTexts.errorServerResponse} (Status code: $statusCode)';

        if (error.response?.data != null && error.response?.data != '') {
          if (error.response!.data is Map<String, dynamic>) {
            final data = error.response!.data as Map<String, dynamic>;
            if (data['errors'] is List && (data['errors'] as List).isNotEmpty) {
              final list = data['errors'] as List;
              final messages = list.map((e) {
                if (e is Map) {
                  return e['detail'] ?? e['message'] ?? e['error'] ?? e.toString();
                }
                return e.toString();
              }).where((m) => m != null && m.toString().isNotEmpty).join('\n');

              message = messages.isNotEmpty ? messages : (data['detail']?.toString() ?? defaultMessage);
            } else {
              final rawMessage = data['detail'] ?? data['message'] ?? data['error'];
              if (rawMessage != null) {
                message = rawMessage.toString();
              } else {
                message = data.toString();
              }
            }
          } else if (error.response!.data is String) {
            message = error.response!.data as String;
          } else {
            message = error.response!.data.toString();
          }
        } else if (error.error != null && error.error.toString().isNotEmpty) {
          message = error.error.toString();
        } else if (statusCode == 401) {
          message = defaultMessage;
        } else if (error.message != null && error.message != '') {
          message = error.message ?? defaultMessage;
        } else {
          message = defaultMessage;
        }

        AppLogger.warning('Server error ($statusCode): $message | Data: ${error.response?.data}', error: error, stackTrace: error.stackTrace);
        return EitherUtil.failure(HttpFailure.serverError(statusCode, message));

      case DioExceptionType.cancel:
        AppLogger.warning('Request cancelled: ${error.message}', error: error, stackTrace: error.stackTrace);
        return EitherUtil.failure(HttpFailure.cancelled(AppTexts.cancelledError));

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          AppLogger.warning('SocketException: ${error.message}', error: error, stackTrace: error.stackTrace);
          return EitherUtil.failure(HttpFailure.connectionError());
        }

        AppLogger.error('Unexpected Dio error: ${error.message}', error: error, stackTrace: error.stackTrace);
        return EitherUtil.failure(HttpFailure.unexpectedError(error.message ?? AppTexts.unknownError));

      default:
        AppLogger.error('Unhandled Dio error type: ${error.type}, message: ${error.message}', error: error, stackTrace: error.stackTrace);
        return EitherUtil.failure(HttpFailure.unexpectedError(error.message ?? AppTexts.unknownError));
    }
  }

  static Future<EitherUtil<HttpFailure, T>> get<T>(String url, T Function(Map<String, dynamic>) fromJson) async {
    try {
      AppLogger.info('GET Request: $url');

      final response = await _dio.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as Map<String, dynamic>;
        final result = fromJson(data);
        return EitherUtil.success(result);
      } else {
        return EitherUtil.failure(HttpFailure.serverError(response.statusCode ?? 0, AppTexts.errorServerResponse));
      }
    } on DioException catch (error) {
      return _handleError<T>(error);
    } catch (error) {
      AppLogger.error('Unexpected error in GET: $error');
      return EitherUtil.failure(HttpFailure.unexpectedError(error.toString()));
    }
  }

  // Método para endpoints que devuelven arrays directos
  static Future<EitherUtil<HttpFailure, T>> getArray<T>(String url, T Function(List<dynamic>) fromJson) async {
    try {
      AppLogger.info('GET Array Request: $url');

      final response = await _dio.get(url);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is List) {
          final result = fromJson(data);
          return EitherUtil.success(result);
        } else if (data is Map<String, dynamic>) {
          // Si viene envuelto en un objeto, extraer la lista
          final listData = data['data'] ?? data['products'] ?? data['content'] ?? data;
          if (listData is List) {
            final result = fromJson(listData);
            return EitherUtil.success(result);
          }
        }
        return EitherUtil.failure(HttpFailure.serverError(200, AppTexts.unexpectedResponseFormat));
      } else {
        return EitherUtil.failure(HttpFailure.serverError(response.statusCode ?? 0, AppTexts.errorServerResponse));
      }
    } on DioException catch (error) {
      return _handleError<T>(error);
    } catch (error) {
      AppLogger.error('Unexpected error in GET Array: $error');
      return EitherUtil.failure(HttpFailure.unexpectedError(error.toString()));
    }
  }

  static Future<EitherUtil<HttpFailure, T>> post<T>(String url, Map<String, dynamic> data, T Function(Map<String, dynamic>) fromJson) async {
    try {
      AppLogger.info('POST Request: $url, Data: $data');

      final response = await _dio.post(url, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        final result = fromJson(responseData);
        return EitherUtil.success(result);
      } else {
        return EitherUtil.failure(HttpFailure.serverError(response.statusCode ?? 0, AppTexts.errorServerResponse));
      }
    } on DioException catch (error) {
      return _handleError<T>(error);
    } catch (error) {
      AppLogger.error('Unexpected error in POST: $error');
      return EitherUtil.failure(HttpFailure.unexpectedError(error.toString()));
    }
  }

  // Multipart/form-data
  static Future<EitherUtil<HttpFailure, T>> postFormData<T>(
    String url,
    FormData formData,
    T Function(Map<String, dynamic>) fromJson, {
    Future<FormData> Function()? formDataBuilder,
  }) async {
    try {
      AppLogger.info('POST (multipart) Request: $url');

      final response = await _dio.post(
        url,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        final result = fromJson(responseData);
        return EitherUtil.success(result);
      } else {
        return EitherUtil.failure(HttpFailure.serverError(response.statusCode ?? 0, AppTexts.errorServerResponse));
      }
    } on DioException catch (error) {
      if (error.response?.statusCode == 401 && formDataBuilder != null) {
        final refreshed = await tryRefreshToken();
        if (refreshed) {
          try {
            AppLogger.info('Retrying POST (multipart) after token refresh: $url');
            final freshFormData = await formDataBuilder();
            final retryResponse = await _dio.post(url, data: freshFormData);
            if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201) {
              final responseData = retryResponse.data as Map<String, dynamic>;
              return EitherUtil.success(fromJson(responseData));
            }
          } catch (retryError) {
            AppLogger.error('Retry multipart POST failed: $retryError');
          }
        }
      }
      return _handleError<T>(error);
    } catch (error) {
      AppLogger.error('Unexpected error in POST multipart: $error');
      return EitherUtil.failure(HttpFailure.unexpectedError(error.toString()));
    }
  }

  // PUT Multipart/form-data
  static Future<EitherUtil<HttpFailure, T>> putFormData<T>(
    String url,
    FormData formData,
    T Function(Map<String, dynamic>) fromJson, {
    Future<FormData> Function()? formDataBuilder,
  }) async {
    try {
      AppLogger.info('PUT (multipart) Request: $url');

      final response = await _dio.put(
        url,
        data: formData,
      );

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 204) {
        if (response.data != null && response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;
          final result = fromJson(responseData);
          return EitherUtil.success(result);
        } else {
          return EitherUtil.success(fromJson({}));
        }
      } else {
        return EitherUtil.failure(HttpFailure.serverError(response.statusCode ?? 0, AppTexts.errorServerResponse));
      }
    } on DioException catch (error) {
      if (error.response?.statusCode == 401 && formDataBuilder != null) {
        final refreshed = await tryRefreshToken();
        if (refreshed) {
          try {
            AppLogger.info('Retrying PUT (multipart) after token refresh: $url');
            final freshFormData = await formDataBuilder();
            final retryResponse = await _dio.put(url, data: freshFormData);
            if (retryResponse.statusCode == 200 || retryResponse.statusCode == 201 || retryResponse.statusCode == 204) {
              if (retryResponse.data != null && retryResponse.data is Map<String, dynamic>) {
                final responseData = retryResponse.data as Map<String, dynamic>;
                return EitherUtil.success(fromJson(responseData));
              } else {
                return EitherUtil.success(fromJson({}));
              }
            }
          } catch (retryError) {
            AppLogger.error('Retry multipart PUT failed: $retryError');
          }
        }
      }
      return _handleError<T>(error);
    } catch (error) {
      AppLogger.error('Unexpected error in PUT multipart: $error');
      return EitherUtil.failure(HttpFailure.unexpectedError(error.toString()));
    }
  }

  static Future<EitherUtil<HttpFailure, T>> put<T>(String url, Map<String, dynamic> data, T Function(Map<String, dynamic>) fromJson) async {
    try {
      AppLogger.info('PUT Request: $url, Data: $data');

      final response = await _dio.put(url, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        final result = fromJson(responseData);
        return EitherUtil.success(result);
      } else {
        return EitherUtil.failure(HttpFailure.serverError(response.statusCode ?? 0, AppTexts.errorServerResponse));
      }
    } on DioException catch (error) {
      return _handleError<T>(error);
    } catch (error) {
      AppLogger.error('Unexpected error in PUT: $error');
      return EitherUtil.failure(HttpFailure.unexpectedError(error.toString()));
    }
  }

  static Future<EitherUtil<HttpFailure, T>> patch<T>(String url, Map<String, dynamic> data, T Function(Map<String, dynamic>) fromJson) async {
    try {
      AppLogger.info('PATCH Request: $url, Data: $data');

      final response = await _dio.patch(url, data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data as Map<String, dynamic>;
        final result = fromJson(responseData);
        return EitherUtil.success(result);
      } else {
        return EitherUtil.failure(HttpFailure.serverError(response.statusCode ?? 0, AppTexts.errorServerResponse));
      }
    } on DioException catch (error) {
      return _handleError<T>(error);
    } catch (error) {
      AppLogger.error('Unexpected error in PATCH: $error');
      return EitherUtil.failure(HttpFailure.unexpectedError(error.toString()));
    }
  }

  static Future<EitherUtil<HttpFailure, bool>> delete(String url) async {
    try {
      AppLogger.info('DELETE Request: $url');

      final response = await _dio.delete(url);

      if (response.statusCode == 200 || response.statusCode == 204) {
        return EitherUtil.success(true);
      } else {
        return EitherUtil.failure(HttpFailure.serverError(response.statusCode ?? 0, AppTexts.errorServerResponse));
      }
    } on DioException catch (error) {
      return _handleError<bool>(error);
    } catch (error) {
      AppLogger.error('Unexpected error in DELETE: $error');
      return EitherUtil.failure(HttpFailure.unexpectedError(error.toString()));
    }
  }
}
