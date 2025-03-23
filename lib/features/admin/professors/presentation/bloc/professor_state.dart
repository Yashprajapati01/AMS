import 'package:equatable/equatable.dart';
import '../../domain/entities/professor.dart';

abstract class ProfessorState extends Equatable {
  const ProfessorState();
  @override
  List<Object?> get props => [];
}

class ProfessorInitial extends ProfessorState {}

class ProfessorLoading extends ProfessorState {}

class ProfessorLoaded extends ProfessorState {
  final List<Professor> professors;

  const ProfessorLoaded({required this.professors});

  @override
  List<Object?> get props => [professors];
}

class ProfessorError extends ProfessorState {
  final String message;

  const ProfessorError({required this.message});

  @override
  List<Object?> get props => [message];
}
