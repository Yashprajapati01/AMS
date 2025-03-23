import 'package:flutter/material.dart';
import '../../../branches/domain/entities/branch.dart';
import '../../data/repositories/admin_repository_impl.dart';
import 'manage_professors_screen.dart';

class ManageProfessorDepartmentsScreen extends StatefulWidget {
  const ManageProfessorDepartmentsScreen({Key? key}) : super(key: key);

  @override
  State<ManageProfessorDepartmentsScreen> createState() =>
      _ManageProfessorDepartmentsScreenState();
}

class _ManageProfessorDepartmentsScreenState extends State<ManageProfessorDepartmentsScreen> {
  late Future<List<Branch>> _departmentsFuture;

  @override
  void initState() {
    super.initState();
    _departmentsFuture = _fetchDepartments();
  }

  Future<List<Branch>> _fetchDepartments() async {
    final repository = AdminRepositoryImpl();
    return await repository.remoteDataSource.getAllBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Department'),
      ),
      body: FutureBuilder<List<Branch>>(
        future: _departmentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No departments found.'));
          }
          final departments = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final dept = departments[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                child: ListTile(
                  title: Text(dept.name),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageProfessorsScreen(
                          departmentId: dept.id,
                          departmentName: dept.name,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
