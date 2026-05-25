// lib/data/repositories/auth_repository.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/http_client.dart';
import '../models/user.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AuthRepository(dio);
});

class AuthRepository {
  AuthRepository(this._dio);
  final Dio _dio;

  /// Login — returns the JWT access token
  Future<String> login(String email, String password) async {
    final res = await _dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return res.data['access_token'] as String;
  }

  /// Register — creates user in DB and returns JWT access token
  Future<String> register(
    String email,
    String password, {
    String? fullName,
  }) async {
    final res = await _dio.post(
      '/auth/register',
      data: {
        'email':     email,
        'password':  password,
        'full_name': fullName,   // matches RegisterInput field in backend
      },
    );
    return res.data['access_token'] as String;
  }

  /// Fetch current authenticated user profile
  Future<User> getCurrentUser() async {
    final res = await _dio.get('/auth/me');
    return User.fromJson(res.data as Map<String, dynamic>);
  }
}