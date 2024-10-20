import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../entities/Topic.dart';
import '../entities/Post.dart';
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
  // Controller for the Quill Editor
  final quill.QuillController _controller = quill.QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topic: ${widget.topic.title}'),
      ),
      body: Column(
        children: [
          // Topic Header
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
          // List of Posts
          Expanded(
            child: ListView.builder(
              itemCount: widget.topic.posts.length,
              itemBuilder: (context, index) {
                final post = widget.topic.posts[index];
                return PostElement(
                  post: post,
                  onTap: () {
                    // Handle post tapping (future implementation)
                  },
                );
              },
            ),
          ),
        ],
      ),
      // Floating Action Button to add a new post
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreatePostPopup(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Post',
        heroTag: 'addPostFAB',
      ),
    );
  }

  // Helper function to format the date nicely
  String formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }

  // Function to show the popup for creating a new post
  void _showCreatePostPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Create New Post',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: quill.QuillEditor.basic(
                  controller: _controller,

                ),
              ),
              quill.QuillToolbar.simple(
                controller: _controller,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Handle post submission (you can save the post here)
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Post'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
