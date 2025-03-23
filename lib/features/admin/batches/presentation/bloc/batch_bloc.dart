import 'package:flutter_bloc/flutter_bloc.dart';
import 'batch_event.dart';
import 'batch_state.dart';
import '../../domain/usecases/create_batch.dart';
import '../../domain/usecases/get_batches.dart';
import '../../domain/usecases/update_batch.dart';
import '../../domain/usecases/delete_batch.dart';
import '../../data/repositories/admin_repository_impl.dart';

class BatchBloc extends Bloc<BatchEvent, BatchState> {
  final AdminRepositoryImpl adminRepository;
  late final CreateBatch createBatchUseCase;
  late final GetBatches getBatchesUseCase;
  late final UpdateBatch updateBatchUseCase;
  late final DeleteBatch deleteBatchUseCase;

  BatchBloc({required this.adminRepository}) : super(BatchInitial()) {
    createBatchUseCase = CreateBatch(repository: adminRepository);
    getBatchesUseCase = GetBatches(repository: adminRepository);
    updateBatchUseCase = UpdateBatch(repository: adminRepository);
    deleteBatchUseCase = DeleteBatch(repository: adminRepository);

    on<GetBatchesEvent>(_onGetBatches);
    on<CreateBatchEvent>(_onCreateBatch);
    on<UpdateBatchEvent>(_onUpdateBatch);
    on<DeleteBatchEvent>(_onDeleteBatch);
  }

  Future<void> _onGetBatches(GetBatchesEvent event, Emitter<BatchState> emit) async {
    emit(BatchLoading());
    try {
      final batches = await getBatchesUseCase.call();
      emit(BatchLoaded(batches: batches));
    } catch (e) {
      emit(BatchError(message: e.toString()));
    }
  }

  Future<void> _onCreateBatch(CreateBatchEvent event, Emitter<BatchState> emit) async {
    emit(BatchLoading());
    try {
      await createBatchUseCase.call(event.name, event.year);
      final batches = await getBatchesUseCase.call();
      emit(BatchLoaded(batches: batches));
    } catch (e) {
      emit(BatchError(message: e.toString()));
    }
  }

  Future<void> _onUpdateBatch(UpdateBatchEvent event, Emitter<BatchState> emit) async {
    emit(BatchLoading());
    try {
      await updateBatchUseCase.call(event.batchId, event.batchName, event.year);
      final batches = await getBatchesUseCase.call();
      emit(BatchLoaded(batches: batches));
    } catch (e) {
      emit(BatchError(message: e.toString()));
    }
  }

  Future<void> _onDeleteBatch(DeleteBatchEvent event, Emitter<BatchState> emit) async {
    emit(BatchLoading());
    try {
      await deleteBatchUseCase.call(event.batchId);
      final batches = await getBatchesUseCase.call();
      emit(BatchLoaded(batches: batches));
    } catch (e) {
      emit(BatchError(message: e.toString()));
    }
  }
}
