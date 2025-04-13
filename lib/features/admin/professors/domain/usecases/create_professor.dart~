import '../entities/professor.dart';
import '../../data/repositories/admin_repository_impl.dart';

class CreateProfessor {
  final AdminRepositoryImpl repository;

  CreateProfessor({required this.repository});

  Future<Professor> call(String professorUniqueId, String name, int departmentId) async {
    return await repository.createProfessor(professorUniqueId, name, departmentId);
  }
}
