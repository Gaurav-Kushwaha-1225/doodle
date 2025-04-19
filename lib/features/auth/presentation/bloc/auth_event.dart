part of 'auth_bloc.dart';

abstract class AuthEvent {}

class VerifyPhoneNumberEvent extends AuthEvent {
  final String phoneNumber;

  VerifyPhoneNumberEvent({required this.phoneNumber});
}

class VerifyOTPEvent extends AuthEvent {
  final String verificationId;
  final String smsCode;

  VerifyOTPEvent({required this.verificationId, required this.smsCode});
}

class CheckAuthStatusEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}