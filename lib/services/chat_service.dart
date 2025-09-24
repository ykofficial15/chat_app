import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';
import '../utils/storage.dart';

class ChatService {
  static const baseUrl = "http://localhost:5002/api";

  static Future<List<MessageModel>> getMessagesWith(String userId) async {
    final token = AppStorage.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/messages/$userId"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data
          .map(
            (e) => MessageModel(
              from: e['senderId'],
              content: e['content'],
              timestamp: DateTime.parse(e['timestamp']),
            ),
          )
          .toList();
    }
    return [];
  }

  static Future<List<Map>> getUsers() async {
    final token = AppStorage.getToken();
    final response = await http.get(
      Uri.parse("$baseUrl/users"),
      headers: {"Authorization": "Bearer $token"},
    );
    if (response.statusCode == 200) {
      print(response.body);
      final List data = jsonDecode(response.body);
      return data.map((e) => {"id": e['_id'], "email": e['email']}).toList();
    }
    return [];
  }
}
