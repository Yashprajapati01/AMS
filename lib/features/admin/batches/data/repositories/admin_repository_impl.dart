import '../datasources/admin_remote_data_source.dart';
import '../../domain/entities/batch.dart';

class AdminRepositoryImpl {
  final AdminRemoteDataSource remoteDataSource = AdminRemoteDataSource();

  Future<Batch> createBatch(String name, int year) async {
    return await remoteDataSource.createBatch(name, year);
  }

  Future<List<Batch>> getBatches() async {
    return await remoteDataSource.getAllBatches();
  }

  Future<Batch> updateBatch(int batchId, String batchName, int year) async {
    return await remoteDataSource.updateBatch(batchId, batchName, year);
  }

  Future<void> deleteBatch(int batchId) async {
    return await remoteDataSource.deleteBatch(batchId);
  }
}
