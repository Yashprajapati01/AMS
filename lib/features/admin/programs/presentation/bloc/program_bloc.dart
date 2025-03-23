import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_program.dart';
import 'program_event.dart';
import 'program_state.dart';
import '../../domain/usecases/create_program.dart';
import '../../domain/usecases/update_program.dart';
import '../../domain/usecases/delete_program.dart';
import '../../data/repositories/admin_repository_impl.dart';

class ProgramBloc extends Bloc<ProgramEvent, ProgramState> {
  final AdminRepositoryImpl adminRepository;
  late final CreateProgram createProgramUseCase;
  late final GetPrograms getProgramsUseCase;
  late final UpdateProgram updateProgramUseCase;
  late final DeleteProgram deleteProgramUseCase;
  final int batchId;

  ProgramBloc({required this.adminRepository, required this.batchId}) : super(ProgramInitial()) {
    createProgramUseCase = CreateProgram(repository: adminRepository);
    getProgramsUseCase = GetPrograms(repository: adminRepository);
    updateProgramUseCase = UpdateProgram(repository: adminRepository);
    deleteProgramUseCase = DeleteProgram(repository: adminRepository);

    on<GetProgramsEvent>(_onGetPrograms);
    on<CreateProgramEvent>(_onCreateProgram);
    on<UpdateProgramEvent>(_onUpdateProgram);
    on<DeleteProgramEvent>(_onDeleteProgram);
  }

  Future<void> _onGetPrograms(GetProgramsEvent event, Emitter<ProgramState> emit) async {
    emit(ProgramLoading());
    try {
      final programs = await getProgramsUseCase.call(batchId: batchId);
      emit(ProgramLoaded(programs: programs));
    } catch (e) {
      emit(ProgramError(message: e.toString()));
    }
  }

  Future<void> _onCreateProgram(CreateProgramEvent event, Emitter<ProgramState> emit) async {
    emit(ProgramLoading());
    try {
      await createProgramUseCase.call(event.name, event.batchId);
      final programs = await getProgramsUseCase.call(batchId: batchId);
      emit(ProgramLoaded(programs: programs));
    } catch (e) {
      emit(ProgramError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProgram(UpdateProgramEvent event, Emitter<ProgramState> emit) async {
    emit(ProgramLoading());
    try {
      await updateProgramUseCase.call(event.programId, event.name, event.batchId);
      final programs = await getProgramsUseCase.call(batchId: batchId);
      emit(ProgramLoaded(programs: programs));
    } catch (e) {
      emit(ProgramError(message: e.toString()));
    }
  }

  Future<void> _onDeleteProgram(DeleteProgramEvent event, Emitter<ProgramState> emit) async {
    emit(ProgramLoading());
    try {
      await deleteProgramUseCase.call(event.programId);
      final programs = await getProgramsUseCase.call(batchId: batchId);
      emit(ProgramLoaded(programs: programs));
    } catch (e) {
      emit(ProgramError(message: e.toString()));
    }
  }
}
