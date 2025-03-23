import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/program.dart';

class AdminRemoteDataSource {
  final String baseUrl = "http://10.0.2.2:3000/api/admin";

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  // Create a new program
  Future<Program> createProgram(String name, int batchId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/programs');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "program_name": name,
        "batch_id": batchId,
      }),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Program.fromJson(data['program']);
    } else {
      throw Exception('Failed to create program: ${response.body}');
    }
  }

  // Get all programs filtered by batchId
  Future<List<Program>> getAllPrograms({required int batchId}) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/programs?batch_id=$batchId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Program> programs = [];
      for (var item in data['programs']) {
        programs.add(Program.fromJson(item));
      }
      return programs;
    } else {
      throw Exception('Failed to fetch programs: ${response.body}');
    }
  }

  // Update a program
  Future<Program> updateProgram(int programId, String name, int batchId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/programs/$programId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "program_name": name,
        "batch_id": batchId,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Program.fromJson(data['program']);
    } else {
      throw Exception('Failed to update program: ${response.body}');
    }
  }

  // Delete a program
  Future<void> deleteProgram(int programId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/programs/$programId');
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
      throw Exception('Failed to delete program: ${response.body}');
    }
  }
}
