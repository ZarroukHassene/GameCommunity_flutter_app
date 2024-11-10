import 'package:flutter/material.dart';
import 'package:my_blog/models/blog_model.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Function(String) onDelete;
  final String currentUserId;

  const BlogCard({
    Key? key,
    required this.blog,
    required this.onDelete,
    required this.currentUserId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // Implement your navigation logic here to view the blog details
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog Image or Avatar
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blueAccent,
                child: Text(
                  blog.user.name[0].toUpperCase(), // Use the first letter of the user's name
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16.0),

              // Blog Title and Description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blog.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      blog.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    // Blog Metadata (user and timestamp)
                    Row(
                      children: [
                        Text(
                          'By ${blog.user.name}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                            color: Colors.black54,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          blog.comments.length.toString() + ' comments',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Delete Button
              blog.user.id == currentUserId
                  ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  onDelete(blog.id);
                },
              )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
