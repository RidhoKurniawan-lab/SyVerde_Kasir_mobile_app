import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = 
  StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {

  AuthNotifier() : super(AuthInitial());

  Future<void> login(String username, String password) async {
    state = AuthLoading();
    try {
      // Simulasi proses login
      await Future.delayed(const Duration(seconds: 2));
      // Jika berhasil
      state = AuthSuccess();
    } catch (e) {
      // Jika gagal
      state = AuthError(message: 'Login failed');
    }
  }
}

//  STATE 

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}
