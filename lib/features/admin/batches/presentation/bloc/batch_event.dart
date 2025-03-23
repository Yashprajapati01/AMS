import 'package:equatable/equatable.dart';

abstract class BatchEvent extends Equatable {
  const BatchEvent();
  @override
  List<Object?> get props => [];
}

class GetBatchesEvent extends BatchEvent {}

class CreateBatchEvent extends BatchEvent {
  final String name;
  final int year;

  const CreateBatchEvent({required this.name, required this.year});

  @override
  List<Object?> get props => [name, year];
}

class UpdateBatchEvent extends BatchEvent {
  final int batchId;
  final String batchName;
  final int year;

  const UpdateBatchEvent({required this.batchId, required this.batchName, required this.year});

  @override
  List<Object?> get props => [batchId, batchName, year];
}

class DeleteBatchEvent extends BatchEvent {
  final int batchId;

  const DeleteBatchEvent({required this.batchId});

  @override
  List<Object?> get props => [batchId];
}
