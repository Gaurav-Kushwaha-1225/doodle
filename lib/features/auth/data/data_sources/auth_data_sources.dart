import 'package:doodletracker/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onVerificationCompleted,
    required Function(String) onVerificationFailed,
  });
  
  Future<UserModel> verifyOTP({
    required String verificationId,
    required String smsCode,
  });

  Future<UserModel?> getCurrentUser();
  Future<void> signOut();
}