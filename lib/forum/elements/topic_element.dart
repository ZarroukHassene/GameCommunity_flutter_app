import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../entities/Topic.dart';
import '../../entities/Post.dart'; // Import for Post entity
import 'post_element.dart'; // Import for PostElement

class TopicElement extends StatefulWidget {
  final Topic topic;
  final VoidCallback onTap;
  final bool isAdmin;
  final VoidCallback onArchive;

  const TopicElement({
    Key? key,
    required this.topic,
    required this.onTap,
    required this.onArchive,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  _TopicElementState createState() => _TopicElementState();
}

class _TopicElementState extends State<TopicElement> {
  late bool isClosed;
  Post? latestPost;

  @override
  void initState() {
    super.initState();
    isClosed = widget.topic.isClosed;
    _fetchLatestPost(); // Fetch the latest post on init
  }

  // Fetch the latest post for the topic
  Future<void> _fetchLatestPost() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9090/posts/${widget.topic.id}'));

      if (response.statusCode == 200) {
        final List<dynamic> postsData = json.decode(response.body);

        if (postsData.isNotEmpty) {
          // Take the last post from the sorted list as the latest post
          setState(() {
            latestPost = Post.fromJson(postsData.last);
          });
        }
      } else {
        print('Failed to load posts for the topic');
      }
    } catch (e) {
      print('Error fetching latest post: $e');
    }
  }



  Future<void> _toggleTopicStatus(BuildContext context, String field, bool newValue) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:9090/topics/${widget.topic.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({field: newValue}),
      );

      if (response.statusCode == 200) {
        if (field == 'isClosed') {
          setState(() {
            isClosed = newValue;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Topic ${newValue ? 'closed' : 'reopened'} successfully')),
          );
        } else if (field == 'isArchived' && newValue) {
          widget.onArchive();
        }
      } else {
        throw Exception('Failed to update topic');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating topic: $e')),
      );
    }
  }

  void _showConfirmationPopup(BuildContext context, String title, String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isClosed ? Colors.grey[300] : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Topic title and status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.topic.title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '${widget.topic.postIds.length} replies',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (isClosed)
                      Icon(
                        Icons.lock,
                        color: Colors.red,
                        size: 20,
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Text(
              'Creator: ${widget.topic.author.username}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
              ),
            ),
            const Divider(height: 20, thickness: 1.0, color: Colors.grey),

            // Display latest post if available
            if (latestPost != null) ...[
              Text(
                'Latest Post:',
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 8.0),
              PostElement(
                post: latestPost!,
                currentUserId: widget.topic.author.id,
                onTap: () {
                  // Optional: handle post tap if needed
                },
              ),
            ],

            // Admin controls
            if (widget.isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _showConfirmationPopup(
                        context,
                        isClosed ? 'Reopen Topic' : 'Close Topic',
                        isClosed
                            ? 'Are you sure you want to reopen this topic?'
                            : 'Are you sure you want to close this topic?',
                            () => _toggleTopicStatus(context, 'isClosed', !isClosed),
                      );
                    },
                    child: Text(
                      isClosed ? 'Reopen' : 'Close',
                      style: TextStyle(color: isClosed ? Colors.green : Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showConfirmationPopup(
                        context,
                        widget.topic.isArchived ? 'Dust off Topic' : 'Archive Topic',
                        widget.topic.isArchived
                            ? 'Are you sure you want to dust off this topic?'
                            : 'Are you sure you want to archive this topic?',
                            () => _toggleTopicStatus(context, 'isArchived', !widget.topic.isArchived),
                      );
                    },
                    child: Text(
                      widget.topic.isArchived ? 'Dust off' : 'Archive',
                      style: TextStyle(color: widget.topic.isArchived ? Colors.green : Colors.blue),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
