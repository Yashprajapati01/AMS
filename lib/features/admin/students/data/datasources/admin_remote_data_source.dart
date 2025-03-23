import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/student.dart';

// ... other methods for batches, programs, branches

class AdminRemoteDataSource {
  final String baseUrl = "http://10.0.2.2:3000/api/admin";

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  // Students endpoints

  // Create a new student with default password "12345678"
  Future<Student> createStudent(String username, String password, String rollNo, int branchId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/students');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "username": username,
        "password": password,
        "roll_no": rollNo,
        "branch_id": branchId,
      }),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Student.fromJson(data['student']);
    } else {
      throw Exception('Failed to create student: ${response.body}');
    }
  }

  // Get all students filtered by branch_id, excluding password field
  Future<List<Student>> getAllStudents({required int branchId}) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/students?branch_id=$branchId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Student> students = [];
      for (var item in data['students']) {
        students.add(Student.fromJson(item));
      }
      return students;
    } else {
      throw Exception('Failed to fetch students: ${response.body}');
    }
  }

  // Update student (username and roll_no)
  Future<Student> updateStudent(int studentId, String username, String rollNo, int branchId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/students/$studentId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "username": username,
        "roll_no": rollNo,
        "branch_id": branchId,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Student.fromJson(data['student']);
    } else {
      throw Exception('Failed to update student: ${response.body}');
    }
  }

  // Delete student
  Future<void> deleteStudent(int studentId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/students/$studentId');
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
      throw Exception('Failed to delete student: ${response.body}');
    }
  }
}
