import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../entities/Topic.dart';
import '../../entities/Post.dart';
import '../entities/user.dart';
import '../main.dart';
import 'elements/post_element.dart';

class TopicDetailsView extends StatefulWidget {
  final Topic topic;

  const TopicDetailsView({
    Key? key,
    required this.topic,
  }) : super(key: key);

  @override
  _TopicDetailsViewState createState() => _TopicDetailsViewState();
}

class _TopicDetailsViewState extends State<TopicDetailsView> {
  final quill.QuillController _controller = quill.QuillController.basic();
  List<Post> posts = []; // List to store posts

  late User user;

  @override
  void initState() {
    super.initState();
    loadUserData();
    _fetchPosts(); // Fetch posts when the widget is initialized
  }

  Future<void> loadUserData() async {
    try {
      user = (await User.claimCurrentUser())!; // Await the Future
    } catch (error) {
      print('Error retrieving user: $error');
    }
  }
  // Fetch posts for the topic
  Future<void> _fetchPosts() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.43.42:9090/posts/${widget.topic.id}'));

      if (response.statusCode == 200) {
        final List<dynamic> postList = json.decode(response.body);
        setState(() {
          posts = postList.map((json) => Post.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }



  }

  // Delete a post
  Future<void> _deletePost1(String postId) async {
    final response = await http.delete(
      Uri.parse('http://192.168.43.42:9090/posts/$postId'),
    );

    if (response.statusCode == 200) {
      setState(() {
        posts.removeWhere((post) => post.id == postId);
      });
    } else {
      print('Failed to delete post: ${response.body}');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topic: ${widget.topic.title}'),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              border: Border(
                bottom: BorderSide(
                  color: Colors.blueAccent,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.topic.title,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      'Author: ${widget.topic.author.username}',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      'Published: ${formatDate(widget.topic.createdAt)}',
                      style: TextStyle(fontSize: 14.0, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostElement(
                  post: post,
                  currentUserId: "671f66bb914306b644bb0cf3",
                  onTap: () {
                    //_deletePost(post.id); // Trigger delete post when tapped
                  },

                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: (!widget.topic.isClosed && !widget.topic.isArchived)
          ? FloatingActionButton(
        onPressed: () {
          _showCreatePostPopup(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Post',
        heroTag: 'addPostFAB',
      )
          : null, // FloatingActionButton is null if topic is closed or archived
    );
  }


  String formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
// Show the popup for creating a new post
  void _showCreatePostPopup(BuildContext context) {
    final _controller = quill.QuillController.basic();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create New Post',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Toolbar with selected tools
                quill.QuillSimpleToolbar(
                  controller: _controller,
                  configurations: quill.QuillSimpleToolbarConfigurations(
                    showBoldButton: true,
                    showItalicButton: true,
                    showColorButton: true,

                  ),
                ),
                const SizedBox(height: 16.0),
                // Framed text editor
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[400]!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: quill.QuillEditor.basic(
                    controller: _controller,

                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final content = _controller.document.toPlainText().trim();
                    _createNewPost(content);
                    Navigator.of(context).pop();
                  },
                  child: Text('Post'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _createNewPost(String postContent) async {
    try {
      // Ensure the current user is not null
      if (user == null) {
        print('Error: No user logged in.');
        return;
      }

      // Send a POST request to create a new post
      final response = await http.post(
        Uri.parse('http://192.168.43.42:9090/posts/${widget.topic.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'content': postContent,
          'authorId': user.id, // Pass the current user's ID as the author
        }),
      );

      // Check if the response is successful
      if (response.statusCode == 201) {
        // Refresh the posts list to display the new post
        _fetchPosts();
      } else {
        print('Failed to create post: ${response.body}');
      }
    } catch (e) {
      print('Error creating post: $e');
    }
  }
}
