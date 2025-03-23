import 'package:equatable/equatable.dart';
import '../../domain/entities/student.dart';

abstract class StudentState extends Equatable {
  const StudentState();
  @override
  List<Object?> get props => [];
}

class StudentInitial extends StudentState {}

class StudentLoading extends StudentState {}

class StudentLoaded extends StudentState {
  final List<Student> students;
  const StudentLoaded({required this.students});
  @override
  List<Object?> get props => [students];
}

class StudentError extends StudentState {
  final String message;
  const StudentError({required this.message});
  @override
  List<Object?> get props => [message];
}
