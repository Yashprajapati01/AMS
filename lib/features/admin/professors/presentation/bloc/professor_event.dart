import 'package:equatable/equatable.dart';

abstract class ProfessorEvent extends Equatable {
  const ProfessorEvent();
  @override
  List<Object?> get props => [];
}

class GetProfessorsEvent extends ProfessorEvent {
  final int departmentId;

  const GetProfessorsEvent({required this.departmentId});

  @override
  List<Object?> get props => [departmentId];
}

class CreateProfessorEvent extends ProfessorEvent {
  final String professorUniqueId;
  final String name;
  final int departmentId;

  const CreateProfessorEvent({
    required this.professorUniqueId,
    required this.name,
    required this.departmentId,
  });

  @override
  List<Object?> get props => [professorUniqueId, name, departmentId];
}

class UpdateProfessorEvent extends ProfessorEvent {
  final int professorId;
  final String professorUniqueId;
  final String name;
  final int departmentId;

  const UpdateProfessorEvent({
    required this.professorId,
    required this.professorUniqueId,
    required this.name,
    required this.departmentId,
  });

  @override
  List<Object?> get props => [professorId, professorUniqueId, name, departmentId];
}

class DeleteProfessorEvent extends ProfessorEvent {
  final int professorId;

  const DeleteProfessorEvent({required this.professorId});

  @override
  List<Object?> get props => [professorId];
}
