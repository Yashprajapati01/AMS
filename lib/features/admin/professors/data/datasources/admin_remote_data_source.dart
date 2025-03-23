// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../branches/domain/entities/branch.dart';
// // ... other imports for batches, students, etc.
//
// class AdminRemoteDataSource {
//   final String baseUrl = "http://10.0.2.2:3000/api/admin";
//
//   Future<String> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token') ?? '';
//   }
//
//   // Create a new professor
//   Future<Map<String, dynamic>> createProfessor(String professorUniqueId, String name, int departmentId) async {
//     final token = await _getToken();
//     final url = Uri.parse('$baseUrl/professors');
//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token'
//       },
//       body: jsonEncode({
//         "professor_unique_id": professorUniqueId,
//         "name": name,
//         "department_id": departmentId,
//       }),
//     );
//     if (response.statusCode == 201) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to create professor: ${response.body}');
//     }
//   }
//
// // Get professors filtered by department_id
//   Future<List<dynamic>> getAllProfessors({required int departmentId}) async {
//     final token = await _getToken();
//     final url = Uri.parse('$baseUrl/professors?department_id=$departmentId');
//     final response = await http.get(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token'
//       },
//     );
//     if (response.statusCode == 200) {
//       final data = jsonDecode(response.body);
//       return data['professors'];
//     } else {
//       throw Exception('Failed to fetch professors: ${response.body}');
//     }
//   }
//
// // Update a professor
//   Future<Map<String, dynamic>> updateProfessor(int professorId, String professorUniqueId, String name, int departmentId) async {
//     final token = await _getToken();
//     final url = Uri.parse('$baseUrl/professors/$professorId');
//     final response = await http.put(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token'
//       },
//       body: jsonEncode({
//         "professor_unique_id": professorUniqueId,
//         "name": name,
//         "department_id": departmentId,
//       }),
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to update professor: ${response.body}');
//     }
//   }
//
// // Delete a professor
//   Future<Map<String, dynamic>> deleteProfessor(int professorId) async {
//     final token = await _getToken();
//     final url = Uri.parse('$baseUrl/professors/$professorId');
//     final response = await http.delete(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token'
//       },
//     );
//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to delete professor: ${response.body}');
//     }
//   }
//
//
// }


import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../branches/domain/entities/branch.dart';
import '../../domain/entities/professor.dart';

// ... Existing methods for batches, programs, etc.

class AdminRemoteDataSource {
  final String baseUrl = "http://10.0.2.2:3000/api/admin";

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  // Professors endpoints

  Future<Map<String, dynamic>> createProfessor(String professorUniqueId, String name, int departmentId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/professors');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "professor_unique_id": professorUniqueId,
        "name": name,
        "department_id": departmentId,
      }),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create professor: ${response.body}');
    }
  }

  Future<List<Professor>> getAllProfessors({required int departmentId}) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/professors?department_id=$departmentId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Professor> professors = [];
      for (var item in data['professors']) {
        professors.add(Professor.fromJson(item));
      }
      return professors;
    } else {
      throw Exception('Failed to fetch professors: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updateProfessor(int professorId, String professorUniqueId, String name, int departmentId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/professors/$professorId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "professor_unique_id": professorUniqueId,
        "name": name,
        "department_id": departmentId,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update professor: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> deleteProfessor(int professorId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/professors/$professorId');
    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete professor: ${response.body}');
    }
  }

  // Branches: Modify getAllBranches to accept an optional programId.
  // ... existing imports and methods

// Get all branches (departments) without filtering by program
  Future<List<Branch>> getAllBranches() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/branches');
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
}
