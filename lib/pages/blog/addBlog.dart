import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blogrelated/bloc_bloc.dart';

class BlogAddScreen extends StatelessWidget {
  const BlogAddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Blog'),
        backgroundColor: Colors.blueAccent, // Adjust the app bar color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title TextField
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: const TextStyle(color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16.0),

            // Description TextField
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: const TextStyle(color: Colors.blueAccent),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: const BorderSide(color: Colors.blueAccent),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              style: const TextStyle(color: Colors.black),
              maxLines: 5,
            ),
            const SizedBox(height: 20),

            // Add Blog Button
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty && descriptionController.text.isNotEmpty) {
                  // Call the BlogCubit to add the blog
                  BlocProvider.of<BlogCubit>(context).addBlog(
                    titleController.text,
                    descriptionController.text,
                  );
                  Navigator.pop(context); // Go back to the previous screen
                } else {
                  // Show a message if the title or description is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please fill in both fields')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14.0),
              ),
              child: const Text(
                'Add Blog',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}