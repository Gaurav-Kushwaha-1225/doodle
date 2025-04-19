import 'package:doodletracker/features/auth/data/data_sources/auth_data_sources.dart';
import 'package:doodletracker/features/auth/domain/entities/user_entity.dart';
import 'package:doodletracker/features/auth/domain/repos/user_repo.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onVerificationCompleted,
    required Function(String) onVerificationFailed,
  }) async {
    await remoteDataSource.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      onCodeSent: onCodeSent,
      onVerificationCompleted: onVerificationCompleted,
      onVerificationFailed: onVerificationFailed,
    );
  }

  @override
  Future<UserEntity> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    return await remoteDataSource.verifyOTP(
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }
}