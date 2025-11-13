import 'dart:async';

import 'package:al_muslim/core/constants/constants.dart';
import 'package:al_muslim/core/services/network/base_dio.dart';
import 'package:al_muslim/core/services/network/end_points.dart';
import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:al_muslim/modules/auth/managers/mg_auth.dart';
import 'package:al_muslim/core/utils/helper/app_alert.dart';

class DioInterceptor extends Interceptor {
  static const String _retryFlagKey = '__bnbRetried';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final authManager = Modular.get<MgAuth>();
    final accessToken = authManager.getActiveUser()?.accessToken ?? '';
    options.headers['Authorization'] = 'Bearer $accessToken';

    final isRefreshCall = options.path.contains(APIEndPoints.auth.refreshToken);
    final isLogoutCall = options.path.contains(APIEndPoints.auth.logout);

    if (Constants.isRefreshingToken && !isRefreshCall && !isLogoutCall) {
      Constants.pendingRequests.add(PendingRequest(requestOptions: options, handler: handler));
      return;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final code = response.statusCode ?? 0;
    final requestOptions = response.requestOptions;

    if (code == 401) {
      final isRefreshCall =
          requestOptions.path.contains(APIEndPoints.auth.refreshToken) ||
          requestOptions.path.contains(APIEndPoints.auth.logout);

      final authManager = Modular.get<MgAuth>();

      if (isRefreshCall || (requestOptions.extra[_retryFlagKey] == true)) {
        await _handleUnauthorized(authManager);
        return handler.reject(_buildUnauthorizedException(requestOptions, response), true);
      }

      final existingRefresh = Constants.refreshCompleter?.future;

      if (existingRefresh != null) {
        final refreshed = await existingRefresh;
        if (!refreshed) {
          await _handleUnauthorized(authManager, clearQueue: true);
          return handler.reject(_buildUnauthorizedException(requestOptions, response), true);
        }

        try {
          await _processQueuedRequests(authManager);
          final retryResponse = await _retryRequest(requestOptions, authManager);
          return handler.resolve(retryResponse);
        } on DioException catch (dioError) {
          if (dioError.response?.statusCode == 401) {
            await _handleUnauthorized(authManager, clearQueue: true);
          }
          return handler.reject(dioError, true);
        } catch (error) {
          return handler.reject(_buildUnknownException(requestOptions, response, error), true);
        }
      }

      final completer = Completer<bool>();
      Constants.refreshCompleter = completer;
      Constants.isRefreshingToken = true;

      final hasRefreshed = await authManager.refreshToken();
      Constants.isRefreshingToken = false;
      completer.complete(hasRefreshed);
      Constants.refreshCompleter = null;

      if (!hasRefreshed) {
        await _handleUnauthorized(authManager, clearQueue: true);
        return handler.reject(_buildUnauthorizedException(requestOptions, response), true);
      }

      try {
        await _processQueuedRequests(authManager);
        final retryResponse = await _retryRequest(requestOptions, authManager);
        return handler.resolve(retryResponse);
      } on DioException catch (dioError) {
        if (dioError.response?.statusCode == 401) {
          await _handleUnauthorized(authManager, clearQueue: true);
        }
        return handler.reject(dioError, true);
      } catch (error) {
        return handler.reject(_buildUnknownException(requestOptions, response, error), true);
      }
    }

    if (code >= 400) {
      final data = response.data;
      if (data is Map) {
        final detail = data['detail'];
        if (detail is String && detail.trim().isNotEmpty) {
          AppAlert.error(detail);
        }
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    String errorMessage = 'Error occurred: ';
    // Try to surface backend `detail` message first
    final data = err.response?.data;
    if (data is Map) {
      final detail = data['detail'];
      if (detail is String && detail.trim().isNotEmpty) {
        AppAlert.error(detail);
      }
    }

    if (err.response != null) {
      // Handling based on status code
      switch (err.response?.statusCode) {
        case 400:
          errorMessage += 'Unauthorized Exception: ${err.response?.data.toString()}';
          break;
        case 500:
          errorMessage += 'Server Exception: ${err.response?.data.toString()}';
          break;
        default:
          errorMessage += 'Unknown API Exception: ${err.response?.data.toString()}';
          break;
      }
    } else {
      // Handling other Dio errors
      switch (err.type) {
        case DioExceptionType.connectionTimeout:
          errorMessage += 'Connection timeout';
          break;
        case DioExceptionType.sendTimeout:
          errorMessage += 'Send timeout';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage += 'Receive timeout';
          break;
        case DioExceptionType.badCertificate:
          errorMessage += 'Bad Certificate';
          break;
        case DioExceptionType.cancel:
          errorMessage += 'Request cancelled';
          break;
        case DioExceptionType.connectionError:
          errorMessage += 'Connection Error';
          break;
        case DioExceptionType.unknown:
          errorMessage += 'Request unknown: ${err.error}';
          break;
        case DioExceptionType.badResponse:
          errorMessage += 'Bad Response: ${err.error}';
          break;
      }
    }

    // Modify the error and pass it along
    DioException modifiedError = DioException(
      requestOptions: err.requestOptions,
      error: errorMessage,
      type: err.type,
      response: err.response,
    );

    return handler.next(modifiedError);
  }

  Future<void> _processQueuedRequests(MgAuth authManager) async {
    if (Constants.pendingRequests.isEmpty) {
      return;
    }

    final queued = List<PendingRequest>.from(Constants.pendingRequests);
    Constants.pendingRequests.clear();

    final refreshedToken = authManager.getActiveUser()?.accessToken ?? '';
    for (final pending in queued) {
      pending.requestOptions.extra[_retryFlagKey] = true;
      pending.requestOptions.headers['Authorization'] = 'Bearer $refreshedToken';
      pending.handler.next(pending.requestOptions);
    }
  }

  Future<void> _handleUnauthorized(MgAuth authManager, {bool clearQueue = false}) async {
    if (clearQueue) {
      _clearQueuedRequests();
    }
    Constants.isRefreshingToken = false;
    final refreshCompleter = Constants.refreshCompleter;
    if (refreshCompleter != null && !refreshCompleter.isCompleted) {
      refreshCompleter.complete(false);
    }
    Constants.refreshCompleter = null;
    await authManager.logout();
  }

  void _clearQueuedRequests() {
    if (Constants.pendingRequests.isEmpty) {
      return;
    }
    final queued = List<PendingRequest>.from(Constants.pendingRequests);
    Constants.pendingRequests.clear();

    for (final pending in queued) {
      pending.handler.reject(
        DioException(
          requestOptions: pending.requestOptions,
          type: DioExceptionType.badResponse,
          error: 'Unauthorized request',
        ),
      );
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions, MgAuth authManager) async {
    requestOptions.extra[_retryFlagKey] = true;
    final refreshedToken = authManager.getActiveUser()?.accessToken ?? '';
    requestOptions.headers['Authorization'] = 'Bearer $refreshedToken';
    return await BaseDio.dio.fetch<dynamic>(requestOptions);
  }

  DioException _buildUnauthorizedException(RequestOptions requestOptions, Response response) {
    return DioException(
      requestOptions: requestOptions,
      response: response,
      type: DioExceptionType.badResponse,
      error: 'Unauthorized request',
    );
  }

  DioException _buildUnknownException(RequestOptions requestOptions, Response response, Object error) {
    return DioException(
      requestOptions: requestOptions,
      response: response,
      type: DioExceptionType.unknown,
      error: error,
    );
  }
}
