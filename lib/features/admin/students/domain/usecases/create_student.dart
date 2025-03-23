import '../entities/student.dart';
import '../../data/repositories/admin_repository_impl.dart';

class CreateStudent {
  final AdminRepositoryImpl repository;

  CreateStudent({required this.repository});

  // Here we use a default password "12345678"
  Future<Student> call(String username, String rollNo, int branchId) async {
    return await repository.createStudent(username, "12345678", rollNo, branchId);
  }
}
