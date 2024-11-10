import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CreateBlogScreen extends StatefulWidget {
  const CreateBlogScreen({super.key});

  @override
  _CreateBlogScreenState createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  // Function to create a blog post
  Future<void> _createBlog() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      _showErrorDialog('Please fill in all fields.');
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2:5000/api/blogs'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'title': _titleController.text,
        'description': _descriptionController.text,
      }),
    );

    if (response.statusCode == 201) {
      Navigator.pop(context); // Go back to the home page
    } else {
      final responseData = json.decode(response.body);
      final errorMessage = responseData['message'] ?? 'Failed to create blog. Please try again.';
      _showErrorDialog(errorMessage);
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Blog'),
        backgroundColor: const Color(0xFF1E2636),
      ),
      backgroundColor: const Color(0xFF1E2636),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Blog Title Input
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Blog Title',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),

            // Blog Description Input
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Blog Description',
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
              maxLines: 5,
            ),
            const SizedBox(height: 16),

            // Create Blog Button
            Container(
              margin: const EdgeInsets.all(20.0), // 20px margin from all sides
              width: double.infinity, // Makes the container take up the full width
              child: ElevatedButton(
                onPressed: _createBlog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Button color
                  padding: const EdgeInsets.symmetric(vertical: 12), // Vertical padding
                  textStyle: const TextStyle(fontSize: 16), // Text style
                ),
                child: const Text('Create Blog'),
              ),
            )

          ],
        ),
      ),
    );
  }
}
