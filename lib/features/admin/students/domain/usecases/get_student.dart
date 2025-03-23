import '../entities/student.dart';
import '../../data/repositories/admin_repository_impl.dart';

class GetStudents {
  final AdminRepositoryImpl repository;

  GetStudents({required this.repository});

  Future<List<Student>> call({required int branchId}) async {
    return await repository.getStudents(branchId: branchId);
  }
}
