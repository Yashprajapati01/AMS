import 'package:flutter/material.dart';

import 'features/admin/batches/presentation/screens/manage_batches_screen.dart';
import 'features/admin/professors/presentation/screens/manage_professor_departments_screen.dart';


class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  // Define the pages for each tab.
  final List<Widget> _pages = [
    // Dashboard home with summary cards or welcome message.
    DashboardHomeScreen(),
    // Manage Batches Screen
    const ManageBatchesScreen(),
    // Manage Professors Screen (assuming a default departmentId for demo)
    const ManageProfessorDepartmentsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree),
            label: 'Batches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Professors',
          ),
        ],
      ),
    );
  }
}

class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can add more summary information, charts, or quick stats here.
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Text(
            'Welcome to the Admin Dashboard!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Colors.blue.shade100,
                  child: SizedBox(
                    height: 100,
                    child: Center(child: Text('Total Batches', style: Theme.of(context).textTheme.titleLarge)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Card(
                  color: Colors.orange.shade100,
                  child: SizedBox(
                    height: 100,
                    child: Center(child: Text('Total Professors', style: Theme.of(context).textTheme.titleLarge)),
                  ),
                ),
              ),
            ],
          ),
          // Add more summary cards or charts as needed.
        ],
      ),
    );
  }
}
