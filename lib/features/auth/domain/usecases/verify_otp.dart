import 'package:doodletracker/features/auth/domain/entities/user_entity.dart';
import 'package:doodletracker/features/auth/domain/repos/user_repo.dart';

class VerifyOTPUseCase {
  final AuthRepository repository;

  VerifyOTPUseCase(this.repository);

  Future<UserEntity> call({
    required String verificationId,
    required String smsCode,
  }) async {
    return await repository.verifyOTP(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }
}