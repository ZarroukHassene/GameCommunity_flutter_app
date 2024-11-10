import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../entities/Post.dart';

class PostElement extends StatelessWidget {
  final Post post;
  final String currentUserId;
  final VoidCallback? onTap;

  const PostElement({
    Key? key,
    required this.post,
    required this.currentUserId,
    this.onTap,
  }) : super(key: key);

  bool get isLiked => post.userLikes.contains(currentUserId);

  Future<void> _toggleLike() async {
    final url = Uri.parse('http://10.0.2.2:9090/posts/likePost');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': currentUserId,
        'postId': post.id,
      }),
    );

    if (response.statusCode == 200) {
      // Toggle the like status locally or refresh the state as needed
      print(isLiked ? 'Post unliked' : 'Post liked');
    } else {
      // Handle error
      print('Error toggling like status: ${response.body}');
    }
  }

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
            Text(
              post.content,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'By: ${post.author.username}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Text(
                      'Posted on: ${formatDate(post.createdAt)}',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: _toggleLike,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String formatDate(DateTime date) {
    return '${date.day}-${date.month}-${date.year}';
  }
}

