import '../entities/professor.dart';
import '../../data/repositories/admin_repository_impl.dart';

class GetProfessors {
  final AdminRepositoryImpl repository;

  GetProfessors({required this.repository});

  Future<List<Professor>> call({required int departmentId}) async {
    return await repository.getProfessors(departmentId: departmentId);
  }
}
