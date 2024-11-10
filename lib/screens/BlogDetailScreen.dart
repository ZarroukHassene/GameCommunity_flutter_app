import 'package:flutter/material.dart';
import 'package:my_blog/models/blog_model.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  const BlogDetailScreen({super.key, required this.blog});

  // Function to delete a comment
  Future<void> _deleteComment(BuildContext context, String blogId, String commentId) async {
    try {
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:5000/api/blogs/$blogId/comments/$commentId'),
      );

      if (response.statusCode == 200) {
        // Comment deleted successfully, show a success message or update the UI
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comment deleted successfully')),
        );
      } else {
        // Handle error if needed
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete comment')),
        );
      }
    } catch (error) {
      print('Error deleting comment: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(blog.title),
        backgroundColor: const Color(0xFF1E2636),
      ),
      backgroundColor: const Color(0xFF1E2636),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Blog Title
            Text(
              blog.title,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
            ),
            const SizedBox(height: 8),
            // Blog Description
            Text(
              blog.description,
              style: TextStyle(color: Colors.grey[300]),
            ),
            const SizedBox(height: 16),
            // Comments Section
            Text(
              'Comments (${blog.comments.length})',
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: blog.comments.length,
                itemBuilder: (context, index) {
                  final comment = blog.comments[index];
                  return Card(
                    color: const Color(0xFF2A364A),
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      title: Text(comment.text, style: const TextStyle(color: Colors.white)),
                      subtitle: Text(
                        DateFormat.yMMMd().format(comment.createdAt as DateTime),
                        style: TextStyle(color: Colors.grey[400]),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          // Show confirmation dialog for comment deletion
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Comment'),
                              content: const Text('Are you sure you want to delete this comment?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _deleteComment(context, blog.id, comment.id);
                                    Navigator.of(context).pop(); // Close dialog
                                  },
                                  child: const Text('Yes'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(), // Close dialog
                                  child: const Text('No'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
