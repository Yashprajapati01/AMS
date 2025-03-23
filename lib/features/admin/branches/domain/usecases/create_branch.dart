import '../entities/branch.dart';
import '../../data/repositories/admin_repository_impl.dart';

class CreateBranch {
  final AdminRepositoryImpl repository;

  CreateBranch({required this.repository});

  Future<Branch> call(String name, int programId) async {
    return await repository.createBranch(name, programId);
  }
}
