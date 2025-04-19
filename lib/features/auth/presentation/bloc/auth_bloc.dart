// ignore_for_file: unused_field

import 'dart:async';

import 'package:doodletracker/features/auth/domain/entities/user_entity.dart';
import 'package:doodletracker/features/auth/domain/usecases/get_current_user.dart';
import 'package:doodletracker/features/auth/domain/usecases/signout.dart';
import 'package:doodletracker/features/auth/domain/usecases/verify_otp.dart';
import 'package:doodletracker/features/auth/domain/usecases/verify_phone.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final VerifyPhoneUseCase verifyPhoneUseCase;
  final VerifyOTPUseCase verifyOTPUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignOutUseCase signOutUseCase;

  String? _verificationId;

  AuthBloc({
    required this.verifyPhoneUseCase,
    required this.verifyOTPUseCase,
    required this.getCurrentUserUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial()) {
    on<VerifyPhoneNumberEvent>(_onVerifyPhoneNumber);
    on<VerifyOTPEvent>(_onVerifyOTP);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<SignOutEvent>(_onSignOut);
    on<CodeSentEvent>((event, emit) {
      emit(AuthCodeSent(verificationId: event.verificationId));
    });
    on<AuthErrorEvent>((event, emit) {
      emit(AuthError(message: event.message));
    });
  }

  Future<void> _onVerifyPhoneNumber(
    VerifyPhoneNumberEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await verifyPhoneUseCase(
        phoneNumber: event.phoneNumber,
        onCodeSent: (String verificationId) {
          _verificationId = verificationId;
          add(CodeSentEvent(verificationId: verificationId));
        },
        onVerificationCompleted: (String message) {
          add(AuthDoneEvent());
        },
        onVerificationFailed: (String message) {
          add(AuthErrorEvent(message: message));
        },
      );
    } catch (e) {
      add(AuthErrorEvent(message: e.toString()));
    }
  }

  Future<void> _onVerifyOTP(
    VerifyOTPEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await verifyOTPUseCase(
        verificationId: event.verificationId,
        smsCode: event.smsCode,
      );
      emit(AuthVerified(user: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onCheckAuthStatus(
    CheckAuthStatusEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await getCurrentUserUseCase();
      if (user != null) {
        emit(AuthVerified(user: user));
      } else {
        emit(AuthLoggedOut());
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await signOutUseCase();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
