import 'package:equatable/equatable.dart';
import '../../domain/entities/batch.dart';

abstract class BatchState extends Equatable {
  const BatchState();
  @override
  List<Object?> get props => [];
}

class BatchInitial extends BatchState {}

class BatchLoading extends BatchState {}

class BatchLoaded extends BatchState {
  final List<Batch> batches;

  const BatchLoaded({required this.batches});

  @override
  List<Object?> get props => [batches];
}

class BatchError extends BatchState {
  final String message;

  const BatchError({required this.message});

  @override
  List<Object?> get props => [message];
}
