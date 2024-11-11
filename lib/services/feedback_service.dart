import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/feedback.dart'; // Import the Feedback model

Future<void> sendFeedback(String sender, String subject, String messageBody) async {
  final url = Uri.parse('http://localhost:9090/feedback'); // Replace with your backend URL

  final feedback = Feedback(sender: sender, subject: subject, messageBody: messageBody);

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json', // Ensure the server expects JSON data
      },
      body: json.encode(feedback.toJson()), // Encode the feedback object as JSON
    );

    if (response.statusCode == 200) {
      print('Feedback sent successfully!');
    } else {
      print('Failed to send feedback: ${response.statusCode}');
    }
  } catch (error) {
    print('Error sending feedback: $error');
  }
}
