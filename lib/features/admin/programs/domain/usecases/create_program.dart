import '../entities/program.dart';
import '../../data/repositories/admin_repository_impl.dart';

class CreateProgram {
  final AdminRepositoryImpl repository;

  CreateProgram({required this.repository});

  Future<Program> call(String name, int batchId) async {
    return await repository.createProgram(name, batchId);
  }
}
