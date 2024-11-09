import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Import the http package
import 'dart:convert';  // Import for JSON encoding

class FeedbackScreen extends StatefulWidget {
  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController senderController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Function to send feedback to the backend
  Future<void> sendFeedback(String sender, String subject, String messageBody) async {
    final url = Uri.parse('http://localhost:4000/api/feedback'); // Use correct URL with port 4000

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'sender': sender,
          'subject': subject,
          'messageBody': messageBody,
        }),
      );

      if (response.statusCode == 200) {
        print('Feedback sent successfully!');
      } else {
        print('Error sending feedback: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending feedback: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Send Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: senderController,
              decoration: InputDecoration(
                labelText: 'Sender',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: messageController,
              decoration: InputDecoration(
                labelText: 'Message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Call sendFeedback function when the button is pressed
                final sender = senderController.text;
                final subject = subjectController.text;
                final messageBody = messageController.text;

                // Send the feedback
                sendFeedback(sender, subject, messageBody);

                // Clear the input fields after sending
                senderController.clear();
                subjectController.clear();
                messageController.clear();
              },
              child: Text('Send Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}
