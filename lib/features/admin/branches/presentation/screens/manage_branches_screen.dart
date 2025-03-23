import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../students/presentation/screens/manage_students_screens.dart';
import '../bloc/branch_bloc.dart';
import '../bloc/branch_event.dart';
import '../bloc/branch_state.dart';
import '../../data/repositories/admin_repository_impl.dart';

class ManageBranchesScreen extends StatelessWidget {
  final int programId;
  final String programName;

  const ManageBranchesScreen({Key? key, required this.programId, required this.programName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
      BranchBloc(adminRepository: AdminRepositoryImpl(), programId: programId)
        ..add(GetBranchesEvent(programId: programId)),
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            appBar: AppBar(title: Text('Branches for $programName')),
            body: BlocBuilder<BranchBloc, BranchState>(
              builder: (context, state) {
                if (state is BranchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is BranchLoaded) {
                  if (state.branches.isEmpty) {
                    return const Center(child: Text('No branches found.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.branches.length,
                    itemBuilder: (context, index) {
                      final branch = state.branches[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            branch.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateBranchDialog(blocContext, branch);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _confirmDeleteBranch(blocContext, branch.id);
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            // Navigate to ManageStudentsScreen for this branch.
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ManageStudentsScreen(
                                  branchId: branch.id,
                                  branchName: branch.name,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (state is BranchError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Container();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showCreateBranchDialog(blocContext),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  void _showCreateBranchDialog(BuildContext context) {
    final _nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Branch'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Branch Name'),
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
                    const SnackBar(content: Text('Please enter a valid branch name')),
                  );
                  return;
                }
                context.read<BranchBloc>().add(CreateBranchEvent(name: name, programId: programId));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateBranchDialog(BuildContext context, dynamic branch) {
    final _nameController = TextEditingController(text: branch.name);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Branch'),
          content: TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Branch Name'),
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
                    const SnackBar(content: Text('Please enter a valid branch name')),
                  );
                  return;
                }
                context
                    .read<BranchBloc>()
                    .add(UpdateBranchEvent(branchId: branch.id, name: name, programId: programId));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteBranch(BuildContext context, int branchId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this branch?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<BranchBloc>().add(DeleteBranchEvent(branchId: branchId));
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
