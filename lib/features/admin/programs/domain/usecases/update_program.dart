import '../entities/program.dart';
import '../../data/repositories/admin_repository_impl.dart';

class UpdateProgram {
  final AdminRepositoryImpl repository;

  UpdateProgram({required this.repository});

  Future<Program> call(int programId, String name, int batchId) async {
    return await repository.updateProgram(programId, name, batchId);
  }
}
