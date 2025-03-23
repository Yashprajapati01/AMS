import '../entities/branch.dart';
import '../../data/repositories/admin_repository_impl.dart';

class GetBranches {
  final AdminRepositoryImpl repository;

  GetBranches({required this.repository});

  Future<List<Branch>> call({required int programId}) async {
    return await repository.getBranches(programId: programId);
  }
}
