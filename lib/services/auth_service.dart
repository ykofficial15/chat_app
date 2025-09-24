import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/storage.dart';

class AuthService {
  static const baseUrl = "http://localhost:5002/api/auth";

  static Future<String?> signup(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/signup"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['token'];
      final userId = body['user']?['id']; // save user id if present

      if (token != null) await AppStorage.saveToken(token);
      if (userId != null) await AppStorage.saveUserId(userId); // save user id

      return token;
    }
    return null;
  }

  static Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['token'];
      final userId = body['user']?['id'];

      if (token != null) await AppStorage.saveToken(token);
      if (userId != null) await AppStorage.saveUserId(userId);

      return token;
    }
    return null;
  }
}
