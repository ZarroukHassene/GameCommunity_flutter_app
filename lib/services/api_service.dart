import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> sendMessage(String sender, String receiver, String message) async {
  final url = Uri.parse('http://localhost:4000/api/chats/messages');

  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'sender': sender,
        'receiver': receiver,
        'content': message,
      }),
    );

    if (response.statusCode == 201) {
      print('Message sent successfully');
    } else {
      print('Failed to send message: ${response.body}');
    }
  } catch (error) {
    print('Error sending message: $error');
  }
}
