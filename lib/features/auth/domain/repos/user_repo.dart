import 'package:doodletracker/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onVerificationCompleted,
    required Function(String) onVerificationFailed,
  });
  
  Future<UserEntity> verifyOTP({
    required String verificationId,
    required String smsCode,
  });

  Future<UserEntity?> getCurrentUser();
  Future<void> signOut();
}