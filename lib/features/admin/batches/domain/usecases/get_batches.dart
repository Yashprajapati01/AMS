import '../entities/batch.dart';
import '../../data/repositories/admin_repository_impl.dart';

class GetBatches {
  final AdminRepositoryImpl repository;

  GetBatches({required this.repository});

  Future<List<Batch>> call() async {
    return await repository.getBatches();
  }
}
