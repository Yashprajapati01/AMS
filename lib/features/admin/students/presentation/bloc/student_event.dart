import 'package:equatable/equatable.dart';

abstract class StudentEvent extends Equatable {
  const StudentEvent();
  @override
  List<Object?> get props => [];
}

class GetStudentsEvent extends StudentEvent {
  final int branchId;
  const GetStudentsEvent({required this.branchId});
  @override
  List<Object?> get props => [branchId];
}

class CreateStudentEvent extends StudentEvent {
  final String username;
  final String rollNo;
  final int branchId;
  const CreateStudentEvent({required this.username, required this.rollNo, required this.branchId});
  @override
  List<Object?> get props => [username, rollNo, branchId];
}

class UpdateStudentEvent extends StudentEvent {
  final int studentId;
  final String username;
  final String rollNo;
  final int branchId;
  const UpdateStudentEvent({required this.studentId, required this.username, required this.rollNo, required this.branchId});
  @override
  List<Object?> get props => [studentId, username, rollNo, branchId];
}

class DeleteStudentEvent extends StudentEvent {
  final int studentId;
  const DeleteStudentEvent({required this.studentId});
  @override
  List<Object?> get props => [studentId];
}
