import 'package:doodletracker/features/auth/domain/entities/user_entity.dart';
import 'package:doodletracker/features/auth/domain/repos/user_repo.dart';

class GetCurrentUserUseCase {
  final AuthRepository repository;

  GetCurrentUserUseCase(this.repository);

  Future<UserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}