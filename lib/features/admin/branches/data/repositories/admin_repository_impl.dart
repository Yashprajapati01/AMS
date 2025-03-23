import '../../domain/entities/branch.dart';
import '../datasources/admin_remote_data_source.dart';

class AdminRepositoryImpl {
  final AdminRemoteDataSource remoteDataSource = AdminRemoteDataSource();
  // Branches
  Future<Branch> createBranch(String name, int programId) async {
    return await remoteDataSource.createBranch(name, programId);
  }

  Future<List<Branch>> getBranches({required int programId}) async {
    return await remoteDataSource.getAllBranches(programId: programId);
  }

  Future<Branch> updateBranch(int branchId, String name, int programId) async {
    return await remoteDataSource.updateBranch(branchId, name, programId);
  }

  Future<void> deleteBranch(int branchId) async {
    return await remoteDataSource.deleteBranch(branchId);
  }

}
