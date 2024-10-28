import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:gamefan_app/forum/posts_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../entities/Topic.dart';
import '../entities/ForumUser.dart';
import '../entities/TopicCategory.dart';
import '../main.dart';
import 'elements/topic_element.dart';
import 'package:provider/provider.dart';

class TopicsListView extends StatefulWidget {
  final TopicCategory category;
  final bool isAdmin;


  const TopicsListView({
    Key? key,
    required this.category,
    required this.isAdmin,
  }) : super(key: key);

  @override
  _TopicsListViewState createState() => _TopicsListViewState();
}

class _TopicsListViewState extends State<TopicsListView> {
  List<Topic> _topics = [];
  // Quill editor controller for rich text post content
  final quill.QuillController _quillController = quill.QuillController.basic();

  @override
  void initState() {
    super.initState();
    _fetchTopics();
  }

  // Fetch topics for the category
  Future<void> _fetchTopics() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9090/topics/${widget.category.id}'));

      if (response.statusCode == 200) {
        final List<dynamic> topicList = json.decode(response.body);
        setState(() {
          print(response.body);
          print(topicList);
          _topics = topicList.map((json) => Topic.fromJson(json)).toList();
        });
      } else {
        throw Exception('Failed to load topics');
      }
    } catch (e) {
      print('Error fetching topics: $e');
    }
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
              Navigator.push( // Navigate to the topic details view
                context,
                MaterialPageRoute(
                  builder: (context) => TopicDetailsView(topic: topic),
                ),

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
                quill.QuillEditor(
                  controller: _quillController,
                  scrollController: ScrollController(),
                  focusNode: FocusNode(),
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

  // API call to create a new topic
  Future<void> _createNewTopic(String title, String postContent) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    //final currentUser = userProvider.currentUser;
    FUser currentUser = FUser(id: '671ec40066de43881f2b6c53', username: 'hassen');
    if (title.isEmpty || postContent.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:9090/topics/${widget.category.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': title,
          'authorId': currentUser?.id ?? '',
          'initialPost': postContent,
        }),
      );

      if (response.statusCode == 201) {
        _fetchTopics(); // Refresh the topics list
      } else {
        print('Failed to create topic: ${response.body}');
      }
    } catch (e) {
      print('Error creating topic: $e');
    }
  }
}
