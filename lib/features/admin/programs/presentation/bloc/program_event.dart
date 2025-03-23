import 'package:equatable/equatable.dart';

abstract class ProgramEvent extends Equatable {
  const ProgramEvent();
  @override
  List<Object?> get props => [];
}

class GetProgramsEvent extends ProgramEvent {}

class CreateProgramEvent extends ProgramEvent {
  final String name;
  final int batchId;

  const CreateProgramEvent({required this.name, required this.batchId});

  @override
  List<Object?> get props => [name, batchId];
}

class UpdateProgramEvent extends ProgramEvent {
  final int programId;
  final String name;
  final int batchId;

  const UpdateProgramEvent({required this.programId, required this.name, required this.batchId});

  @override
  List<Object?> get props => [programId, name, batchId];
}

class DeleteProgramEvent extends ProgramEvent {
  final int programId;

  const DeleteProgramEvent({required this.programId});

  @override
  List<Object?> get props => [programId];
}
