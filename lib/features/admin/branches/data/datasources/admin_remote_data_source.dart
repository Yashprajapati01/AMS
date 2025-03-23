import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/branch.dart';
// ... other imports for batches, students, etc.

class AdminRemoteDataSource {
  final String baseUrl = "http://10.0.2.2:3000/api/admin";

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  // Existing methods for batches and programs here...

  // Branches endpoints

  // Create a new branch
  Future<Branch> createBranch(String name, int programId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/branches');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "branch_name": name,
        "program_id": programId,
      }),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Branch.fromJson(data['branch']);
    } else {
      throw Exception('Failed to create branch: ${response.body}');
    }
  }

  // Get all branches filtered by programId
  Future<List<Branch>> getAllBranches({required int programId}) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/branches?program_id=$programId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Branch> branches = [];
      for (var item in data['branches']) {
        branches.add(Branch.fromJson(item));
      }
      return branches;
    } else {
      throw Exception('Failed to fetch branches: ${response.body}');
    }
  }

  // Update a branch
  Future<Branch> updateBranch(int branchId, String name, int programId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/branches/$branchId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "branch_name": name,
        "program_id": programId,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Branch.fromJson(data['branch']);
    } else {
      throw Exception('Failed to update branch: ${response.body}');
    }
  }

  // Delete a branch
  Future<void> deleteBranch(int branchId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/branches/$branchId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception('Failed to delete branch: ${response.body}');
    }
  }
}
