import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../programs/presentation/screens/manage_program_screens.dart';
import '../bloc/batch_bloc.dart';
import '../bloc/batch_event.dart';
import '../bloc/batch_state.dart';
import '../../data/repositories/admin_repository_impl.dart';

class ManageBatchesScreen extends StatelessWidget {
  const ManageBatchesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BatchBloc(adminRepository: AdminRepositoryImpl())..add(GetBatchesEvent()),
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            appBar: AppBar(title: const Text('Manage Batches')),
            body: BlocBuilder<BatchBloc, BatchState>(
              builder: (context, state) {
                if (state is BatchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BatchLoaded) {
                  if (state.batches.isEmpty) {
                    return const Center(child: Text('No batches found.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.batches.length,
                    itemBuilder: (context, index) {
                      final batch = state.batches[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            batch.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Year: ${batch.year}'),
                          onTap: () {
                            // Navigate to the ManageProgramsScreen for this batch.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageProgramsScreen(
                                  batchId: batch.id,
                                  batchName: batch.name,
                                ),
                              ),
                            );
                          },
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateBatchDialog(blocContext, batch);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _confirmDeleteBatch(blocContext, batch.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is BatchError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Container();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showCreateBatchDialog(blocContext),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  void _showCreateBatchDialog(BuildContext context) {
    final _nameController = TextEditingController();
    final _yearController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Batch'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Batch Name'),
              ),
              TextField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final year = int.tryParse(_yearController.text.trim()) ?? 0;
                if (name.isEmpty || year <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid batch details')),
                  );
                  return;
                }
                context.read<BatchBloc>().add(CreateBatchEvent(name: name, year: year));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateBatchDialog(BuildContext context, dynamic batch) {
    final _nameController = TextEditingController(text: batch.name);
    final _yearController = TextEditingController(text: batch.year.toString());

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Batch'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Batch Name'),
              ),
              TextField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Year'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                final year = int.tryParse(_yearController.text.trim()) ?? 0;
                if (name.isEmpty || year <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid batch details')),
                  );
                  return;
                }
                context.read<BatchBloc>().add(UpdateBatchEvent(batchId: batch.id, batchName: name, year: year));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteBatch(BuildContext context, int batchId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this batch?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<BatchBloc>().add(DeleteBatchEvent(batchId: batchId));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}


//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../programs/presentation/screens/manage_students_screens.dart';
// import '../bloc/batch_bloc.dart';
// import '../bloc/batch_event.dart';
// import '../bloc/batch_state.dart';
// import '../../data/repositories/admin_repository_impl.dart';
//
// class ManageBatchesScreen extends StatelessWidget {
//   const ManageBatchesScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     // Provide the BatchBloc for this screen.
//     return BlocProvider(
//       create: (_) =>
//       BatchBloc(adminRepository: AdminRepositoryImpl())..add(GetBatchesEvent()),
//       child: Builder(
//         builder: (blocContext) {
//           return Scaffold(
//             appBar: AppBar(title: const Text('Manage Batches')),
//             body: BlocBuilder<BatchBloc, BatchState>(
//               builder: (context, state) {
//                 if (state is BatchLoading) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is BatchLoaded) {
//                   if (state.batches.isEmpty) {
//                     return const Center(child: Text('No batches found.'));
//                   }
//                   return ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: state.batches.length,
//                     itemBuilder: (context, index) {
//                       final batch = state.batches[index];
//                       return Card(
//                         margin: const EdgeInsets.only(bottom: 12),
//                         elevation: 2,
//                         child: ListTile(
//                           title: Text(
//                             batch.name,
//                             style: const TextStyle(fontWeight: FontWeight.bold),
//                           ),
//                           subtitle: Text('Year: ${batch.year}'),
//                           onTap: () {
//                             // Navigate to the ManageProgramsScreen for this batch.
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ManageProgramsScreen(
//                                   batchId: batch.id,
//                                   batchName: batch.name,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   );
//                 } else if (state is BatchError) {
//                   return Center(child: Text('Error: ${state.message}'));
//                 }
//                 return Container();
//               },
//             ),
//             floatingActionButton: FloatingActionButton(
//               onPressed: () => _showCreateBatchDialog(blocContext),
//               child: const Icon(Icons.add),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   void _showCreateBatchDialog(BuildContext context) {
//     final _nameController = TextEditingController();
//     final _yearController = TextEditingController();
//
//     showDialog(
//       context: context,
//       builder: (dialogContext) {
//         return AlertDialog(
//           title: const Text('Create Batch'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: 'Batch Name'),
//               ),
//               TextField(
//                 controller: _yearController,
//                 decoration: const InputDecoration(labelText: 'Year'),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.of(dialogContext).pop(),
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 final name = _nameController.text.trim();
//                 final year = int.tryParse(_yearController.text.trim()) ?? 0;
//                 if (name.isEmpty || year <= 0) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Please enter valid batch details')),
//                   );
//                   return;
//                 }
//                 context.read<BatchBloc>().add(CreateBatchEvent(name: name, year: year));
//                 Navigator.of(dialogContext).pop();
//               },
//               child: const Text('Create'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
