import '../../data/repositories/admin_repository_impl.dart';

class DeleteProfessor {
  final AdminRepositoryImpl repository;

  DeleteProfessor({required this.repository});

  Future<void> call(int professorId) async {
    return await repository.deleteProfessor(professorId);
  }
}
