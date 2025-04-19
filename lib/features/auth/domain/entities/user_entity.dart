class UserEntity {
  final String uid;
  final String? phoneNumber;
  final bool isVerified;

  UserEntity({
    required this.uid,
    this.phoneNumber,
    required this.isVerified,
  });
}