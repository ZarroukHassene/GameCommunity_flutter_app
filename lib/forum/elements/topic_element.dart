import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../entities/Topic.dart';

class TopicElement extends StatelessWidget {
  final Topic topic;
  final VoidCallback onTap;
  final bool isAdmin;

  const TopicElement({
    Key? key,
    required this.topic,
    required this.onTap,
    this.isAdmin = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: topic.isClosed ? Colors.grey[300] : Colors.grey[200],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    topic.title,
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
                      '${topic.postIds.length} replies',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (topic.isClosed)
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
              'Creator: ${topic.author.username}',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 10.0),
            if (isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _showConfirmationPopup(
                        context,
                        topic.isClosed ? 'Reopen Topic' : 'Close Topic',
                        topic.isClosed
                            ? 'Are you sure you want to reopen this topic?'
                            : 'Are you sure you want to close this topic?',
                            () => _toggleTopicStatus(context, 'isClosed', !topic.isClosed),
                      );
                    },
                    child: Text(
                      topic.isClosed ? 'Reopen' : 'Close',
                      style: TextStyle(color: topic.isClosed ? Colors.green : Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showConfirmationPopup(
                        context,
                        topic.isArchived ? 'Dust off Topic' : 'Archive Topic',
                        topic.isArchived
                            ? 'Are you sure you want to dust off this topic?'
                            : 'Are you sure you want to archive this topic?',
                            () => _toggleTopicStatus(context, 'isArchived', !topic.isArchived),
                      );
                    },
                    child: Text(
                      topic.isArchived ? 'Dust off' : 'Archive',
                      style: TextStyle(color: topic.isArchived ? Colors.green : Colors.blue),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleTopicStatus(BuildContext context, String field, bool newValue) async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:9090/topics/${topic.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({field: newValue}),
      );

      if (response.statusCode == 200) {
        print("Topic $field updated successfully.");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Topic ${field == 'isClosed' ? (newValue ? 'closed' : 'reopened') : (newValue ? 'archived' : 'dusted off')} successfully')),
        );
      } else {
        throw Exception('Failed to update topic');
      }
    } catch (e) {
      print('Error updating topic: $e');
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
}
