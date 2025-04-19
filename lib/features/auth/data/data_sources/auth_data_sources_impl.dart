import 'package:doodletracker/features/auth/data/data_sources/auth_data_sources.dart';
import 'package:doodletracker/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthRemoteDataSourceImpl(this._firebaseAuth);

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onVerificationCompleted,
    required Function(String) onVerificationFailed,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Only call verification completed if auto-verification happens
          onVerificationCompleted('Phone number automatically verified');
        },
        verificationFailed: (FirebaseAuthException e) {
          String errorMessage = 'Verification failed';
          if (e.code == 'invalid-phone-number') {
            errorMessage = 'The provided phone number is not valid';
          } else if (e.code == 'too-many-requests') {
            errorMessage = 'Too many attempts. Please try again later';
          } else if (e.code == 'network-request-failed') {
            errorMessage = 'Network error. Please check your connection';
          }
          onVerificationFailed(errorMessage);
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Don't emit any state here as it might interfere with the flow
        },
        forceResendingToken: null,
      );
    } catch (e) {
      onVerificationFailed(e.toString());
    }
  }

  @override
  Future<UserModel> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    
    if (userCredential.user != null) {
      return UserModel.fromFirebaseUser(userCredential.user!);
    } else {
      throw Exception("Verification failed");
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      return UserModel.fromFirebaseUser(user);
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
