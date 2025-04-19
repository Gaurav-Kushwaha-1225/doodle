part of 'auth_bloc.dart';

abstract class AuthEvent {}

class VerifyPhoneNumberEvent extends AuthEvent {
  final String phoneNumber;

  VerifyPhoneNumberEvent({required this.phoneNumber});
}

class CodeSentEvent extends AuthEvent {
  final String verificationId;
  CodeSentEvent({required this.verificationId});
}

class AuthErrorEvent extends AuthEvent {
  final String message;
  AuthErrorEvent({required this.message});
}

class AuthDoneEvent extends AuthEvent {
  AuthDoneEvent();
}

class VerifyOTPEvent extends AuthEvent {
  final String verificationId;
  final String smsCode;

  VerifyOTPEvent({required this.verificationId, required this.smsCode});
}

class CheckAuthStatusEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}