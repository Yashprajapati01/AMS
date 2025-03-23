import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/batch.dart';

class AdminRemoteDataSource {
  final String baseUrl = "http://10.0.2.2:3000/api/admin";

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token') ?? '';
  }

  Future<Batch> createBatch(String name, int year) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/batches');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "batch_name": name,
        "year": year,
      }),
    );
    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Batch.fromJson(data['batch']);
    } else {
      throw Exception('Failed to create batch: ${response.body}');
    }
  }

  Future<List<Batch>> getAllBatches() async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/batches');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<Batch> batches = [];
      for (var item in data['batches']) {
        batches.add(Batch.fromJson(item));
      }
      return batches;
    } else {
      throw Exception('Failed to fetch batches: ${response.body}');
    }
  }

  // Update Batch
  Future<Batch> updateBatch(int batchId, String batchName, int year) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/batches/$batchId');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({
        "batch_name": batchName,
        "year": year,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Batch.fromJson(data['batch']);
    } else {
      throw Exception('Failed to update batch: ${response.body}');
    }
  }

  // Delete Batch
  Future<void> deleteBatch(int batchId) async {
    final token = await _getToken();
    final url = Uri.parse('$baseUrl/batches/$batchId');
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
      throw Exception('Failed to delete batch: ${response.body}');
    }
  }
}
