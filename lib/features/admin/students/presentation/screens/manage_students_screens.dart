import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/student_bloc.dart';
import '../bloc/student_event.dart';
import '../bloc/student_state.dart';
import '../../data/repositories/admin_repository_impl.dart';

class ManageStudentsScreen extends StatelessWidget {
  final int branchId;
  final String branchName;

  const ManageStudentsScreen({Key? key, required this.branchId, required this.branchName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentBloc(adminRepository: AdminRepositoryImpl(), branchId: branchId)
        ..add(GetStudentsEvent(branchId: branchId)),
      child: Builder(
        builder: (blocContext) {
          return Scaffold(
            appBar: AppBar(title: Text('Students for $branchName')),
            body: BlocBuilder<StudentBloc, StudentState>(
              builder: (context, state) {
                if (state is StudentLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is StudentLoaded) {
                  if (state.students.isEmpty) {
                    return const Center(child: Text('No students found.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.students.length,
                    itemBuilder: (context, index) {
                      final student = state.students[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            student.rollNo,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Name: ${student.username}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showUpdateStudentDialog(blocContext, student);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _confirmDeleteStudent(blocContext, student.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is StudentError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                return Container();
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => _showCreateStudentDialog(blocContext),
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }

  void _showCreateStudentDialog(BuildContext context) {
    final _usernameController = TextEditingController();
    final _rollNoController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Create Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Student Name'),
                ),
                TextField(
                  controller: _rollNoController,
                  decoration: const InputDecoration(labelText: 'Roll Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final username = _usernameController.text.trim();
                final rollNo = _rollNoController.text.trim();
                if (username.isEmpty || rollNo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid student details')),
                  );
                  return;
                }
                context.read<StudentBloc>().add(
                  CreateStudentEvent(username: username, rollNo: rollNo, branchId: branchId),
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

  void _showUpdateStudentDialog(BuildContext context, dynamic student) {
    final _usernameController = TextEditingController(text: student.username);
    final _rollNoController = TextEditingController(text: student.roll_no ?? student.rollNo);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Update Student'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(labelText: 'Student Name'),
                ),
                TextField(
                  controller: _rollNoController,
                  decoration: const InputDecoration(labelText: 'Roll Number'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final username = _usernameController.text.trim();
                final rollNo = _rollNoController.text.trim();
                if (username.isEmpty || rollNo.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter valid student details')),
                  );
                  return;
                }
                context.read<StudentBloc>().add(
                  UpdateStudentEvent(
                    studentId: student.id,
                    username: username,
                    rollNo: rollNo,
                    branchId: branchId,
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

  void _confirmDeleteStudent(BuildContext context, int studentId) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<StudentBloc>().add(DeleteStudentEvent(studentId: studentId));
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
