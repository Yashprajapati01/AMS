import '../entities/batch.dart';
import '../../data/repositories/admin_repository_impl.dart';

class CreateBatch {
  final AdminRepositoryImpl repository;

  CreateBatch({required this.repository});

  Future<Batch> call(String name, int year) async {
    return await repository.createBatch(name, year);
  }
}
