import '../datasources/admin_remote_data_source.dart';
import '../../domain/entities/professor.dart';
// ... other imports

class AdminRepositoryImpl {
  final AdminRemoteDataSource remoteDataSource = AdminRemoteDataSource();

  // ... methods for batches, programs, branches, students

  // Professors
  Future<Professor> createProfessor(String professorUniqueId, String name, int departmentId) async {
    final data = await remoteDataSource.createProfessor(professorUniqueId, name, departmentId);
    return Professor.fromJson(data['professor']);
  }

  // REMOVED mapping here because remoteDataSource.getAllProfessors already returns List<Professor>
  Future<List<Professor>> getProfessors({required int departmentId}) async {
    return await remoteDataSource.getAllProfessors(departmentId: departmentId);
  }

  Future<Professor> updateProfessor(int professorId, String professorUniqueId, String name, int departmentId) async {
    final data = await remoteDataSource.updateProfessor(professorId, professorUniqueId, name, departmentId);
    return Professor.fromJson(data['professor']);
  }

  Future<void> deleteProfessor(int professorId) async {
    await remoteDataSource.deleteProfessor(professorId);
  }
}
