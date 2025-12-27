import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/user_model.dart';
import 'package:frontend/data/repositories/auth/auth_repository.dart';
import 'package:frontend/data/services/api/auth_api.dart';

// DEPENDENCY 

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(authApiProvider));
});


//  STATE 

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

//NOTIFIER

final authProvider = 
  StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository repository;

  AuthNotifier(this.repository) : super(AuthInitial());

  Future<void> login(
    String email, 
    String password
    ) async {

    state = AuthLoading();
    
    try {
       final user = await repository.login(email, password);
      state = AuthSuccess(user);

    } catch (e) {
      // Jika gagal
      state = AuthError(e.toString().replaceAll('Exception:', '').trim());
    }
  }
}
