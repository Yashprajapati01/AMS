import 'package:equatable/equatable.dart';
import '../../domain/entities/program.dart';

abstract class ProgramState extends Equatable {
  const ProgramState();
  @override
  List<Object?> get props => [];
}

class ProgramInitial extends ProgramState {}

class ProgramLoading extends ProgramState {}

class ProgramLoaded extends ProgramState {
  final List<Program> programs;

  const ProgramLoaded({required this.programs});

  @override
  List<Object?> get props => [programs];
}

class ProgramError extends ProgramState {
  final String message;

  const ProgramError({required this.message});

  @override
  List<Object?> get props => [message];
}
