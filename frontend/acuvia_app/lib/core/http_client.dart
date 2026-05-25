import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final dioProvider = Provider<Dio>((ref) {
  // Android emulator → 10.0.2.2, iOS simulator → 127.0.0.1
  String baseUrl;
  if (Platform.isAndroid) {
    baseUrl = dotenv.env['API_BASE_URL_ANDROID'] ?? 'http://10.0.2.2:8000';
  } else {
    baseUrl = dotenv.env['API_BASE_URL_IOS'] ?? 'http://127.0.0.1:8000';
  }

  final dio = Dio(
    BaseOptions(
      baseUrl: '$baseUrl/api/v1',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 60), // longer for MedGemma
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Auth token interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final token = ref.read(authTokenProvider);
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        // Log errors clearly in VSCode debug console
        debugPrint('❌ API Error [${error.response?.statusCode}]: '
            '${error.requestOptions.path} → ${error.message}');
        return handler.next(error);
      },
    ),
  );

  return dio;
});

final authTokenProvider = StateProvider<String?>((_) => null);