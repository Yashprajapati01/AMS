import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/professor_bloc.dart';
import '../bloc/professor_event.dart';
import '../bloc/professor_state.dart';
import '../../data/repositories/admin_repository_impl.dart';

class ManageProfessorsScreen extends StatelessWidget {
  final int departmentId;
  final String departmentName;

  const ManageProfessorsScreen({Key? key, required this.departmentId, required this.departmentName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfessorBloc(adminRepository: AdminRepositoryImpl(), departmentId: departmentId)
        ..add(GetProfessorsEvent(departmentId: departmentId)),
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            appBar: AppBar(title: Text('Professors in $departmentName')),
            body: BlocBuilder<ProfessorBloc, ProfessorState>(
              builder: (context, state) {
                if (state is ProfessorLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is ProfessorLoaded) {
                  if (state.professors.isEmpty) {
                    return const Center(child: Text('No professors found.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.professors.length,
                    itemBuilder: (context, index) {
                      final professor = state.professors[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            professor.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Unique ID: ${professor.professorUniqueId}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateProfessorDialog(blocContext, professor);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _confirmDeleteProfessor(blocContext, professor.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is ProfessorError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Container();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showCreateProfessorDialog(blocContext),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  Future<List<dynamic>> _fetchDepartments() async {
    final repository = AdminRepositoryImpl();
    final departments = await repository.remoteDataSource.getAllBranches();
    return departments.map((dept) => {
      'branch_id': dept.id,
      'branch_name': dept.name,
    }).toList();
  }

  void _showCreateProfessorDialog(BuildContext context) {
    final _uniqueIdController = TextEditingController();
    final _nameController = TextEditingController();
    int selectedDepartment = departmentId;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Professor'),
          content: FutureBuilder<List<dynamic>>(
            future: _fetchDepartments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No departments found.');
              }
              final departments = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _uniqueIdController,
                      decoration: const InputDecoration(labelText: 'Professor Unique ID'),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Professor Name'),
                    ),
                    DropdownButtonFormField<int>(
                      value: selectedDepartment,
                      decoration: const InputDecoration(labelText: 'Department'),
                      items: departments.map<DropdownMenuItem<int>>((dept) {
                        return DropdownMenuItem<int>(
                          value: dept['branch_id'],
                          child: Text(dept['branch_name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedDepartment = value!;
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final uniqueId = _uniqueIdController.text.trim();
                final name = _nameController.text.trim();
                if (uniqueId.isEmpty || name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid professor details')),
                  );
                  return;
                }
                context.read<ProfessorBloc>().add(
                  CreateProfessorEvent(
                    professorUniqueId: uniqueId,
                    name: name,
                    departmentId: selectedDepartment,
                    password: "12345678",
                  ),
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateProfessorDialog(BuildContext context, dynamic professor) {
    final _uniqueIdController = TextEditingController(text: professor.professorUniqueId);
    final _nameController = TextEditingController(text: professor.name);
    int selectedDepartment = departmentId;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Professor'),
          content: FutureBuilder<List<dynamic>>(
            future: _fetchDepartments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text('No departments found.');
              }
              final departments = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _uniqueIdController,
                      decoration: const InputDecoration(labelText: 'Professor Unique ID'),
                    ),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Professor Name'),
                    ),
                    DropdownButtonFormField<int>(
                      value: selectedDepartment,
                      decoration: const InputDecoration(labelText: 'Department'),
                      items: departments.map<DropdownMenuItem<int>>((dept) {
                        return DropdownMenuItem<int>(
                          value: dept['branch_id'],
                          child: Text(dept['branch_name']),
                        );
                      }).toList(),
                      onChanged: (value) {
                        selectedDepartment = value!;
                      },
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final uniqueId = _uniqueIdController.text.trim();
                final name = _nameController.text.trim();
                if (uniqueId.isEmpty || name.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid professor details')),
                  );
                  return;
                }
                context.read<ProfessorBloc>().add(
                  UpdateProfessorEvent(
                    professorId: professor.id,
                    professorUniqueId: uniqueId,
                    name: name,
                    departmentId: selectedDepartment,
                  ),
                );
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDeleteProfessor(BuildContext context, int professorId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this professor?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<ProfessorBloc>().add(DeleteProfessorEvent(professorId: professorId));
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
