import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import '../../entities/Topic.dart';
import '../../entities/Post.dart';
import '../entities/ForumUser.dart';
import '../entities/TopicCategory.dart';
import 'elements/topic_element.dart'; // Assuming your TopicElement is here

class TopicsListView extends StatefulWidget {
  final List<Topic> topics;
  final TopicCategory category;
  final bool isAdmin;

  const TopicsListView({
    Key? key,
    required this.topics,
    required this.category,
    required this.isAdmin,
  }) : super(key: key);

  @override
  _TopicsListViewState createState() => _TopicsListViewState();
}

class _TopicsListViewState extends State<TopicsListView> {
  late List<Topic> _topics;

  // Quill editor controller for rich text post content
  final quill.QuillController _quillController = quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    _topics = widget.topics;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Topics in ${widget.category.name}'),
      ),
      body: ListView.builder(
        itemCount: _topics.length,
        itemBuilder: (context, index) {
          final topic = _topics[index];
          return TopicElement(
            topic: topic,
            isAdmin: widget.isAdmin,
            onTap: () {
              Navigator.pushNamed(
                context,
                "/forum/category/topic",
              );
            },
          );
        },
      ),
      floatingActionButton: widget.isAdmin
          ? FloatingActionButton(
        onPressed: () {
          _showCreateTopicPopup(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Create Topic',
        heroTag: 'createTopicFAB',
      )
          : null,
    );
  }

  // Show the popup for creating a new topic with rich text post content using Quill
  void _showCreateTopicPopup(BuildContext context) {
    final titleController = TextEditingController();

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
                  'Create New Topic',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                // Input for topic title
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Topic Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                // Flutter Quill Editor for rich text post content
                quill.QuillEditor.basic(
                  controller: _quillController,

                ),
                // Quill toolbar for rich text formatting
                quill.QuillToolbar.simple(controller: _quillController),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close the popup
                      },
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Extract the content from Quill editor and create the new topic
                        final postContent = _quillController.document.toPlainText().trim();
                        _createNewTopic(titleController.text, postContent);
                        Navigator.of(context).pop(); // Close the popup
                      },
                      child: Text('Post'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Create a new topic based on the title and rich text post content
  void _createNewTopic(String title, String postContent) {
    if (title.isEmpty || postContent.isEmpty) {
      // Show an error or do nothing if fields are empty
      return;
    }

    // Example admin user (replace with actual logged-in user if necessary)
    final FUser author = FUser(id: 'admin', username: 'Admin');

    // Create the first post with rich text content
    final Post newPost = Post(
      id: 'p${_topics.length + 1}', // Unique post ID
      content: postContent,
      author: author,
    );

    // Create the new topic
    final Topic newTopic = Topic(
      id: 't${_topics.length + 1}', // Unique topic ID
      title: title,
      author: author,
      posts: [newPost],
    );

    // Add the new topic to the list and update the UI
    setState(() {
      _topics.add(newTopic);
    });
  }
}
