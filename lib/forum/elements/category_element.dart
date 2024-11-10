import 'package:flutter/material.dart';
import '../../entities/TopicCategory.dart';
import '../../entities/Topic.dart'; // Assuming Topic class is in entities folder
import 'topic_element.dart'; // Import for TopicElement if exists

class CategoryElement extends StatelessWidget {
  final TopicCategory category;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const CategoryElement({
    Key? key,
    required this.category,
    this.onTap,
    this.onDelete,
    this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final int openTopicsCount = category.topics.where((topic) => !topic.isClosed).length;
    final Topic? latestTopic = category.topics.isNotEmpty ? category.topics.last : null;

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    '$openTopicsCount topics open',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  if (latestTopic != null) ...[
                    Text(
                      'Latest Topic:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    TopicElement(
                      topic: latestTopic,
                      onTap: () {
                        // Navigate to the topic details
                      },
                      isAdmin: false, onArchive: () {  }, // Set to true if admin actions are needed
                    ),
                  ],
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (onEdit != null)
                  IconButton(
                    onPressed: onEdit,
                    icon: Icon(Icons.edit, color: Colors.green),
                    tooltip: 'Edit Category',
                  ),
                if (onDelete != null)
                  IconButton(
                    onPressed: onDelete,
                    icon: Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Delete Category',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
