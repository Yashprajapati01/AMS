import '../../data/repositories/admin_repository_impl.dart';

class DeleteStudent {
  final AdminRepositoryImpl repository;

  DeleteStudent({required this.repository});

  Future<void> call(int studentId) async {
    return await repository.deleteStudent(studentId);
  }
}
