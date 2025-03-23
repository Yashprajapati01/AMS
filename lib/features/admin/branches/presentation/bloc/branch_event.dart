import 'package:equatable/equatable.dart';

abstract class BranchEvent extends Equatable {
  const BranchEvent();
  @override
  List<Object?> get props => [];
}

class GetBranchesEvent extends BranchEvent {
  final int programId;

  const GetBranchesEvent({required this.programId});

  @override
  List<Object?> get props => [programId];
}

class CreateBranchEvent extends BranchEvent {
  final String name;
  final int programId;

  const CreateBranchEvent({required this.name, required this.programId});

  @override
  List<Object?> get props => [name, programId];
}

class UpdateBranchEvent extends BranchEvent {
  final int branchId;
  final String name;
  final int programId;

  const UpdateBranchEvent({required this.branchId, required this.name, required this.programId});

  @override
  List<Object?> get props => [branchId, name, programId];
}

class DeleteBranchEvent extends BranchEvent {
  final int branchId;

  const DeleteBranchEvent({required this.branchId});

  @override
  List<Object?> get props => [branchId];
}
