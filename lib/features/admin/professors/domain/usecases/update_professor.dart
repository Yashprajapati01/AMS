import '../entities/professor.dart';
import '../../data/repositories/admin_repository_impl.dart';

class UpdateProfessor {
  final AdminRepositoryImpl repository;

  UpdateProfessor({required this.repository});

  Future<Professor> call(int professorId, String professorUniqueId, String name, int departmentId) async {
    return await repository.updateProfessor(professorId, professorUniqueId, name, departmentId);
  }
}
