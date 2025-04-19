import 'package:doodletracker/features/auth/domain/entities/user_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.uid,
    super.phoneNumber,
    required super.isVerified,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      phoneNumber: user.phoneNumber,
      isVerified: user.phoneNumber != null,
    );
  }
}