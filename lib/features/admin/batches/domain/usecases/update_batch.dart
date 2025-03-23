import '../entities/batch.dart';
import '../../data/repositories/admin_repository_impl.dart';

class UpdateBatch {
  final AdminRepositoryImpl repository;

  UpdateBatch({required this.repository});

  Future<Batch> call(int batchId, String batchName, int year) async {
    return await repository.updateBatch(batchId, batchName, year);
  }
}
