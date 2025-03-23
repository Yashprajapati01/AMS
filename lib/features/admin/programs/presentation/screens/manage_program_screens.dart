import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../branches/presentation/screens/manage_branches_screen.dart';
import '../bloc/program_bloc.dart';
import '../bloc/program_event.dart';
import '../bloc/program_state.dart';
import '../../data/repositories/admin_repository_impl.dart';
class ManageProgramsScreen extends StatelessWidget {
  final int batchId;
  final String batchName;

  const ManageProgramsScreen({Key? key, required this.batchId, required this.batchName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProgramBloc(adminRepository: AdminRepositoryImpl(), batchId: batchId)
        ..add(GetProgramsEvent()),
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            appBar: AppBar(title: Text('Programs for $batchName')),
            body: BlocBuilder<ProgramBloc, ProgramState>(
              builder: (context, state) {
                if (state is ProgramLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProgramLoaded) {
                  if (state.programs.isEmpty) {
                    return const Center(child: Text('No programs found.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.programs.length,
                    itemBuilder: (context, index) {
                      final program = state.programs[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            program.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Batch: $batchName'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateProgramDialog(blocContext, program);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _confirmDeleteProgram(blocContext, program.id);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageBranchesScreen(
                                  programId: program.id,
                                  programName: program.name,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (state is ProgramError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Container();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showCreateProgramDialog(blocContext),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  void _showCreateProgramDialog(BuildContext context) {
    final _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Program'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Program Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid program name')),
                  );
                  return;
                }
                context
                    .read<ProgramBloc>()
                    .add(CreateProgramEvent(name: name, batchId: batchId));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateProgramDialog(BuildContext context, dynamic program) {
    final _nameController = TextEditingController(text: program.name);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Program'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Program Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid program name')),
                  );
                  return;
                }
                context
                    .read<ProgramBloc>()
                    .add(UpdateProgramEvent(programId: program.id, name: name, batchId: batchId));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteProgram(BuildContext context, int programId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this program?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ProgramBloc>().add(DeleteProgramEvent(programId: programId));
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
