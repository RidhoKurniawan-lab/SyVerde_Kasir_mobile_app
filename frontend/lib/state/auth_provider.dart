import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/data/models/response/user_model.dart';
import 'package:frontend/data/repositories/auth_repository.dart';
import 'package:frontend/data/services/api/auth_api.dart';
import 'package:flutter/foundation.dart';

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

class AuthCheckSuccess extends AuthState {}

class AuthLogoutFailed extends AuthState {}

class AuthLogoutSuccess extends AuthState {}

class AuthSuccess extends AuthState {
  final UserModel user;
  AuthSuccess(this.user);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

//NOTIFIER

abstract class UserQueryState {}

class UserQueryInitial extends UserQueryState {}

class UserQueryLoading extends UserQueryState {}

class UserQueryLoaded extends UserQueryState {
  final List<UserModel> users;
  UserQueryLoaded(this.users);
}

class UserQueryError extends UserQueryState {
  final String message;
  UserQueryError(this.message);
}

final userQueryProvider =
    StateNotifierProvider<UserQueryNotifier, UserQueryState>(
      (ref) => UserQueryNotifier(ref.read(authRepositoryProvider)),
    );

class UserQueryNotifier extends StateNotifier<UserQueryState> {
  final AuthRepository repository;

  UserQueryNotifier(this.repository) : super(UserQueryInitial());

  Future<void> getUser() async {
    state = UserQueryLoading();

    try {
      final user = await repository.getUser();
      state = UserQueryLoaded(user);
    } catch (e) {
      state = UserQueryError(
        e.toString().replaceAll('Exception:', '').trim(),
      );
    }
  }
}

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

  Future<void> logout() async {

    state = AuthLoading();
    
    try {

      final response = await repository.logout();
      if (response) {
      state = AuthLogoutSuccess();
      }
      state = AuthLogoutFailed();

    } catch (e) {
      state = AuthError(e.toString().replaceAll('Exception:', '').trim());
    }
  }
}
