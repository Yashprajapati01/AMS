import '../datasources/admin_remote_data_source.dart';
import '../../domain/entities/program.dart';

class AdminRepositoryImpl {
  final AdminRemoteDataSource remoteDataSource = AdminRemoteDataSource();

  Future<Program> createProgram(String name, int batchId) async {
    return await remoteDataSource.createProgram(name, batchId);
  }

  Future<List<Program>> getPrograms({required int batchId}) async {
    return await remoteDataSource.getAllPrograms(batchId: batchId);
  }

  Future<Program> updateProgram(int programId, String name, int batchId) async {
    return await remoteDataSource.updateProgram(programId, name, batchId);
  }

  Future<void> deleteProgram(int programId) async {
    return await remoteDataSource.deleteProgram(programId);
  }
}
