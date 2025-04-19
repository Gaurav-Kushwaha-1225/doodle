part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthCodeSent extends AuthState {
  final String verificationId;

  AuthCodeSent({required this.verificationId});
}

class AuthVerified extends AuthState {
  final UserEntity user;

  AuthVerified({required this.user});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class AuthLoggedOut extends AuthState {}