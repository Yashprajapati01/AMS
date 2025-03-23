import 'package:flutter_bloc/flutter_bloc.dart';
import 'branch_event.dart';
import 'branch_state.dart';
import '../../domain/usecases/create_branch.dart';
import '../../domain/usecases/get_branches.dart';
import '../../domain/usecases/update_branch.dart';
import '../../domain/usecases/delete_branch.dart';
import '../../data/repositories/admin_repository_impl.dart';

class BranchBloc extends Bloc<BranchEvent, BranchState> {
  final AdminRepositoryImpl adminRepository;
  late final CreateBranch createBranchUseCase;
  late final GetBranches getBranchesUseCase;
  late final UpdateBranch updateBranchUseCase;
  late final DeleteBranch deleteBranchUseCase;
  final int programId;

  BranchBloc({required this.adminRepository, required this.programId}) : super(BranchInitial()) {
    createBranchUseCase = CreateBranch(repository: adminRepository);
    getBranchesUseCase = GetBranches(repository: adminRepository);
    updateBranchUseCase = UpdateBranch(repository: adminRepository);
    deleteBranchUseCase = DeleteBranch(repository: adminRepository);

    on<GetBranchesEvent>(_onGetBranches);
    on<CreateBranchEvent>(_onCreateBranch);
    on<UpdateBranchEvent>(_onUpdateBranch);
    on<DeleteBranchEvent>(_onDeleteBranch);
  }

  Future<void> _onGetBranches(GetBranchesEvent event, Emitter<BranchState> emit) async {
    emit(BranchLoading());
    try {
      final branches = await getBranchesUseCase.call(programId: programId);
      emit(BranchLoaded(branches: branches));
    } catch (e) {
      emit(BranchError(message: e.toString()));
    }
  }

  Future<void> _onCreateBranch(CreateBranchEvent event, Emitter<BranchState> emit) async {
    emit(BranchLoading());
    try {
      await createBranchUseCase.call(event.name, event.programId);
      final branches = await getBranchesUseCase.call(programId: programId);
      emit(BranchLoaded(branches: branches));
    } catch (e) {
      emit(BranchError(message: e.toString()));
    }
  }

  Future<void> _onUpdateBranch(UpdateBranchEvent event, Emitter<BranchState> emit) async {
    emit(BranchLoading());
    try {
      await updateBranchUseCase.call(event.branchId, event.name, event.programId);
      final branches = await getBranchesUseCase.call(programId: programId);
      emit(BranchLoaded(branches: branches));
    } catch (e) {
      emit(BranchError(message: e.toString()));
    }
  }

  Future<void> _onDeleteBranch(DeleteBranchEvent event, Emitter<BranchState> emit) async {
    emit(BranchLoading());
    try {
      await deleteBranchUseCase.call(event.branchId);
      final branches = await getBranchesUseCase.call(programId: programId);
      emit(BranchLoaded(branches: branches));
    } catch (e) {
      emit(BranchError(message: e.toString()));
    }
  }
}
