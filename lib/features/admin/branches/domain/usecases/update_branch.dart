import '../entities/branch.dart';
import '../../data/repositories/admin_repository_impl.dart';

class UpdateBranch {
  final AdminRepositoryImpl repository;

  UpdateBranch({required this.repository});

  Future<Branch> call(int branchId, String name, int programId) async {
    return await repository.updateBranch(branchId, name, programId);
  }
}
