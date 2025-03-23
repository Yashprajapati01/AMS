import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_student.dart';
import 'student_event.dart';
import 'student_state.dart';
import '../../domain/usecases/create_student.dart';
import '../../domain/usecases/update_student.dart';
import '../../domain/usecases/delete_student.dart';
import '../../data/repositories/admin_repository_impl.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final AdminRepositoryImpl adminRepository;
  late final CreateStudent createStudentUseCase;
  late final GetStudents getStudentsUseCase;
  late final UpdateStudent updateStudentUseCase;
  late final DeleteStudent deleteStudentUseCase;
  final int branchId;

  StudentBloc({required this.adminRepository, required this.branchId})
      : super(StudentInitial()) {
    createStudentUseCase = CreateStudent(repository: adminRepository);
    getStudentsUseCase = GetStudents(repository: adminRepository);
    updateStudentUseCase = UpdateStudent(repository: adminRepository);
    deleteStudentUseCase = DeleteStudent(repository: adminRepository);

    on<GetStudentsEvent>(_onGetStudents);
    on<CreateStudentEvent>(_onCreateStudent);
    on<UpdateStudentEvent>(_onUpdateStudent);
    on<DeleteStudentEvent>(_onDeleteStudent);
  }

  Future<void> _onGetStudents(GetStudentsEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      final students = await getStudentsUseCase.call(branchId: branchId);
      emit(StudentLoaded(students: students));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  Future<void> _onCreateStudent(CreateStudentEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      await createStudentUseCase.call(event.username, event.rollNo, event.branchId);
      final students = await getStudentsUseCase.call(branchId: branchId);
      emit(StudentLoaded(students: students));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  Future<void> _onUpdateStudent(UpdateStudentEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      await updateStudentUseCase.call(event.studentId, event.username, event.rollNo, event.branchId);
      final students = await getStudentsUseCase.call(branchId: branchId);
      emit(StudentLoaded(students: students));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }

  Future<void> _onDeleteStudent(DeleteStudentEvent event, Emitter<StudentState> emit) async {
    emit(StudentLoading());
    try {
      await deleteStudentUseCase.call(event.studentId);
      final students = await getStudentsUseCase.call(branchId: branchId);
      emit(StudentLoaded(students: students));
    } catch (e) {
      emit(StudentError(message: e.toString()));
    }
  }
}
