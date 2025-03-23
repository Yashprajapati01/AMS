import '../../data/repositories/admin_repository_impl.dart';

class DeleteProgram {
  final AdminRepositoryImpl repository;

  DeleteProgram({required this.repository});

  Future<void> call(int programId) async {
    return await repository.deleteProgram(programId);
  }
}
