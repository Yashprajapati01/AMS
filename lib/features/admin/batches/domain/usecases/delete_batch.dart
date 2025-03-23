import '../../data/repositories/admin_repository_impl.dart';

class DeleteBatch {
  final AdminRepositoryImpl repository;

  DeleteBatch({required this.repository});

  Future<void> call(int batchId) async {
    return await repository.deleteBatch(batchId);
  }
}
