import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepositoryImpl {
  // Adjust the baseUrl as needed
  final String baseUrl = "http://10.0.2.2:3000/api";

  /// Expects backend to return:
  /// { "message": "Login successful", "token": "<JWT_TOKEN>", "role": "student", "name": "John Doe" }
  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "username": username,
        "password": password,
      }),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (kDebugMode) {
        print("Login Response: $data");
      }
      return data;
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }
}
