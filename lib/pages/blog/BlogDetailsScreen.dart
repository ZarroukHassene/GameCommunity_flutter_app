import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BlogDetailsScreen extends StatefulWidget {
  final String blogId;
  final String ownerId;

  const BlogDetailsScreen({required this.blogId, required this.ownerId});

  @override
  _BlogDetailsScreenState createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  dynamic blog = {};
  List<dynamic> comments = [];
  bool isLoading = true;
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchBlogDetails();
  }

  // Fetch blog details including comments
  Future<void> _fetchBlogDetails() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9090/user/blog/${widget.blogId}'));

      if (response.statusCode == 200) {
        setState(() {
          blog = json.decode(response.body);
          comments = blog['comments'] ?? [];  // Safely access 'comments' field
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load blog details');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching blog details: $error");
    }
  }

  // Add a comment to the blog
  Future<void> _addComment() async {
    if (commentController.text.isEmpty) return;

    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      final response = await http.post(
        Uri.parse('http://10.0.2.2:9090/user/comment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'comment': commentController.text,
          'userId': userId,
          'blogId': widget.blogId,
        }),
      );

      if (response.statusCode == 201) {
        setState(() {
          comments.add(json.decode(response.body));
          commentController.clear();
        });
      } else {
        throw Exception('Failed to add comment');
      }
    } catch (error) {
      print("Error adding comment: $error");
    }
  }

  // Delete the blog if the current user is the owner
  Future<void> _deleteBlog() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('user_id');

      if (userId != widget.ownerId) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are not the owner of this blog')));
        return;
      }

      final response = await http.delete(
        Uri.parse('http://10.0.2.2:9090/user/blog/${widget.blogId}'),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context); // Go back to the BlogScreen after deletion
      } else {
        throw Exception('Failed to delete blog');
      }
    } catch (error) {
      print("Error deleting blog: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blog Details'),
        actions: [
          // Ensure the user is the owner of the blog before showing the delete button
          if (widget.ownerId == blog['user']?['_id'])
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteBlog,
            ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display blog title and description
            Text(
              blog['title'] ?? 'No title',  // Default to 'No title' if null
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Text(
              blog['description'] ?? 'No description',  // Default to 'No description' if null
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 20),
            Text(
              'Comments',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // List the comments
            Expanded(
              child: ListView.builder(
                itemCount: comments.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(comments[index]['comment'] ?? 'No comment'),
                    subtitle: Text(comments[index]['user']?['username'] ?? 'Unknown user'),
                  );
                },
              ),
            ),
            // Input for new comment
            TextField(
              controller: commentController,
              decoration: InputDecoration(labelText: 'Add a comment'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addComment,
              child: Text('Submit Comment'),
            ),
          ],
        ),
      ),
    );
  }
}
