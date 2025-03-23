import '../entities/student.dart';
import '../../data/repositories/admin_repository_impl.dart';

class UpdateStudent {
  final AdminRepositoryImpl repository;

  UpdateStudent({required this.repository});

  Future<Student> call(int studentId, String username, String rollNo, int branchId) async {
    return await repository.updateStudent(studentId, username, rollNo, branchId);
  }
}
