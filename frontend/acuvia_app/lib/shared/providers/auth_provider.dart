// lib/shared/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/http_client.dart';
import '../../../data/repositories/auth_repository.dart';

final authStateProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>(
  AuthController.new,
);

class AuthController extends StateNotifier<AsyncValue<void>> {
  AuthController(this._ref) : super(const AsyncValue.data(null));
  final Ref _ref;

  /// Login with email + password → stores JWT token on success
  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final token = await _ref
          .read(authRepositoryProvider)
          .login(email, password);
      _ref.read(authTokenProvider.notifier).state = token;
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Register new user → saves to DB and stores JWT token on success
  Future<bool> register(
    String email,
    String password, {
    String? fullName,
  }) async {
    state = const AsyncValue.loading();
    try {
      final token = await _ref
          .read(authRepositoryProvider)
          .register(email, password, fullName: fullName);
      _ref.read(authTokenProvider.notifier).state = token;
      state = const AsyncValue.data(null);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Google Sign-In placeholder — wire up google_sign_in package when ready
  Future<bool> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      state = const AsyncValue.data(null);
      return false;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      return false;
    }
  }

  /// Clear token — effectively logs the user out
  void logout() {
    _ref.read(authTokenProvider.notifier).state = null;
    state = const AsyncValue.data(null);
  }
}