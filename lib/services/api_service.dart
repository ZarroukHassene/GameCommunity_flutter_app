import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String apiUrl = 'http://localhost:9090'; // Replace with actual backend URL

  static Future<List> getUsers() async {
    final response = await http.get(Uri.parse('$apiUrl/user'));
    return json.decode(response.body);
  }

  static Future<List> getMessages(String userId1, String userId2) async {
    final response = await http.get(Uri.parse('$apiUrl/chat/conversations/$userId1/$userId2'));
    return json.decode(response.body);
  }

  static Future<void> sendMessage(String sender, String receiver, String message) async {
    await http.post(
      Uri.parse('$apiUrl/chat/send'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'sender': sender, 'receiver': receiver, 'message': message}),
    );
  }
}
