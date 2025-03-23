import '../../data/repositories/admin_repository_impl.dart';

class DeleteBranch {
  final AdminRepositoryImpl repository;

  DeleteBranch({required this.repository});

  Future<void> call(int branchId) async {
    return await repository.deleteBranch(branchId);
  }
}
