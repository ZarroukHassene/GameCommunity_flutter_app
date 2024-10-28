import 'package:flutter/material.dart';

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
          color: Colors.white,
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
                Text(
                  '${topic.postIds.length} replies',
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
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
            // Admin-only buttons for "Close" and "Archive"
            if (isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      _showConfirmationPopup(
                        context,
                        'Close Topic',
                        'Are you sure you want to close this topic?',
                            () {
                          // Logic to handle topic closing
                          Navigator.of(context).pop(); // Close the popup
                        },
                      );
                    },
                    child: Text(
                      'Close',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _showConfirmationPopup(
                        context,
                        'Archive Topic',
                        'Are you sure you want to archive this topic?',
                            () {
                          // Logic to handle topic archiving
                          Navigator.of(context).pop(); // Close the popup
                        },
                      );
                    },
                    child: Text(
                      'Archive',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationPopup(BuildContext context, String title, String message, VoidCallback onConfirm) {
    // Implementation of the confirmation popup
    // (You can keep your existing implementation here)
  }
}