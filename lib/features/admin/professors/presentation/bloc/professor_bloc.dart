import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_professor.dart';
import 'professor_event.dart';
import 'professor_state.dart';
import '../../domain/usecases/create_professor.dart';
import '../../domain/usecases/update_professor.dart';
import '../../domain/usecases/delete_professor.dart';
import '../../data/repositories/admin_repository_impl.dart';

class ProfessorBloc extends Bloc<ProfessorEvent, ProfessorState> {
  final AdminRepositoryImpl adminRepository;
  late final CreateProfessor createProfessorUseCase;
  late final GetProfessors getProfessorsUseCase;
  late final UpdateProfessor updateProfessorUseCase;
  late final DeleteProfessor deleteProfessorUseCase;
  final int departmentId;

  ProfessorBloc({required this.adminRepository, required this.departmentId}) : super(ProfessorInitial()) {
    createProfessorUseCase = CreateProfessor(repository: adminRepository);
    getProfessorsUseCase = GetProfessors(repository: adminRepository);
    updateProfessorUseCase = UpdateProfessor(repository: adminRepository);
    deleteProfessorUseCase = DeleteProfessor(repository: adminRepository);

    on<GetProfessorsEvent>(_onGetProfessors);
    on<CreateProfessorEvent>(_onCreateProfessor);
    on<UpdateProfessorEvent>(_onUpdateProfessor);
    on<DeleteProfessorEvent>(_onDeleteProfessor);
  }

  Future<void> _onGetProfessors(GetProfessorsEvent event, Emitter<ProfessorState> emit) async {
    emit(ProfessorLoading());
    try {
      final professors = await getProfessorsUseCase.call(departmentId: departmentId);
      emit(ProfessorLoaded(professors: professors));
    } catch (e) {
      emit(ProfessorError(message: e.toString()));
    }
  }

  Future<void> _onCreateProfessor(CreateProfessorEvent event, Emitter<ProfessorState> emit) async {
    emit(ProfessorLoading());
    try {
      await createProfessorUseCase.call(event.professorUniqueId, event.name, event.departmentId, event.password);
      final professors = await getProfessorsUseCase.call(departmentId: departmentId);
      emit(ProfessorLoaded(professors: professors));
    } catch (e) {
      emit(ProfessorError(message: e.toString()));
    }
  }

  Future<void> _onUpdateProfessor(UpdateProfessorEvent event, Emitter<ProfessorState> emit) async {
    emit(ProfessorLoading());
    try {
      await updateProfessorUseCase.call(event.professorId, event.professorUniqueId, event.name, event.departmentId);
      final professors = await getProfessorsUseCase.call(departmentId: departmentId);
      emit(ProfessorLoaded(professors: professors));
    } catch (e) {
      emit(ProfessorError(message: e.toString()));
    }
  }

  Future<void> _onDeleteProfessor(DeleteProfessorEvent event, Emitter<ProfessorState> emit) async {
    emit(ProfessorLoading());
    try {
      await deleteProfessorUseCase.call(event.professorId);
      final professors = await getProfessorsUseCase.call(departmentId: departmentId);
      emit(ProfessorLoaded(professors: professors));
    } catch (e) {
      emit(ProfessorError(message: e.toString()));
    }
  }
}
