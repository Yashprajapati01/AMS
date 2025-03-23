import '../entities/program.dart';
import '../../data/repositories/admin_repository_impl.dart';

class GetPrograms {
  final AdminRepositoryImpl repository;

  GetPrograms({required this.repository});

  Future<List<Program>> call({required int batchId}) async {
    return await repository.getPrograms(batchId: batchId);
  }
}
