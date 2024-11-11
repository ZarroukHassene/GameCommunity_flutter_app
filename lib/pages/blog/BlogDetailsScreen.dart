import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../entities/Comment.dart';
import '../../entities/user.dart';

class BlogDetailsScreen extends StatefulWidget {
  final String blogId;

  const BlogDetailsScreen({required this.blogId});

  @override
  _BlogDetailsScreenState createState() => _BlogDetailsScreenState();
}

class _BlogDetailsScreenState extends State<BlogDetailsScreen> {
  dynamic blog = {};
  List<dynamic> comments = [];
  bool isLoading = true;
  bool isOwner = false; // Track if the current user is the blog owner
  TextEditingController commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
    _fetchBlogDetails();
  }

  // Load the current user and determine if they are the blog owner
  Future<void> loadUserData() async {
    try {
      User user = (await User.claimCurrentUser())!;
      setState(() {

      });
    } catch (error) {
      print('Error loading user data: $error');
    }
  }

  Future<void> _fetchBlogDetails() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.43.42:9090/user/blog/${widget.blogId}'));
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        setState(() {
          blog = jsonData;
          comments = []; // Clear existing comments
          isLoading = false;
        });

        // Fetch full details for each comment ID
        final List<dynamic> commentIds = jsonData['comments'] ?? [];
        for (var commentId in commentIds) {
          await _fetchCommentDetails(commentId);
        }
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

// Fetch individual comment details by ID
  Future<void> _fetchCommentDetails(String commentId) async {
    try {
      final response = await http.get(Uri.parse('http://192.168.43.42:9090/user/blog/comment/$commentId'));

      if (response.statusCode == 200) {
        final commentData = json.decode(response.body);

        setState(() {
          comments.add(Comment.fromJson(commentData)); // Add each comment to the list
        });
      } else {
        print('Failed to load comment details for ID: $commentId');
      }
    } catch (error) {
      print("Error fetching comment details: $error");
    }
  }





  // Add a comment to the blog
  Future<void> _addComment() async {
    if (commentController.text.isEmpty) return;

    try {
      User user = (await User.claimCurrentUser())!; // Load current user data
      final response = await http.post(
        Uri.parse('http://192.168.43.42:9090/user/blog/comment'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'text': commentController.text, // Use 'text' to match the backend
          'userId': user.id,
          'blogId': widget.blogId,
        }),
      );
      print(json.encode({
        'text': commentController.text, // Make sure it’s 'text' here as well
        'userId': user.id,
        'blogId': widget.blogId,
      }));
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
    if (!isOwner) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are not the owner of this blog')));
      return;
    }

    try {
      final response = await http.delete(
        Uri.parse('http://192.168.43.42:9090/user/blog/${widget.blogId}'),
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
          if (isOwner) // Show delete button only if the user is the owner
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
              blog['title'] ?? 'No title', // Default to 'No title' if null
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 10),
            Text(
              blog['description'] ?? 'No description', // Default to 'No description' if null
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
                  final comment = comments[index] as Comment; // Cast each item to Comment
                  return ListTile(
                    title: Text(comment.commentText),
                    subtitle: Text(comment.username),
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
