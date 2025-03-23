import '../datasources/admin_remote_data_source.dart';
import '../../domain/entities/student.dart';

class AdminRepositoryImpl {
  final AdminRemoteDataSource remoteDataSource = AdminRemoteDataSource();

  // Students
  Future<Student> createStudent(String username, String password, String rollNo, int branchId) async {
    return await remoteDataSource.createStudent(username, "12345678", rollNo, branchId);
  }
  Future<List<Student>> getStudents({required int branchId}) async {
    return await remoteDataSource.getAllStudents(branchId: branchId);
  }
  Future<Student> updateStudent(int studentId, String username, String rollNo, int branchId) async {
    return await remoteDataSource.updateStudent(studentId, username, rollNo, branchId);
  }
  Future<void> deleteStudent(int studentId) async {
    return await remoteDataSource.deleteStudent(studentId);
  }
}
