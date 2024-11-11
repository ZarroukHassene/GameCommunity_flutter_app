import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../entities/Post.dart';

class PostElement extends StatefulWidget {
  final Post post;
  final String currentUserId;
  final VoidCallback? onTap;

  const PostElement({
    Key? key,
    required this.post,
    required this.currentUserId,
    this.onTap,
  }) : super(key: key);

  @override
  _PostElementState createState() => _PostElementState();
}

class _PostElementState extends State<PostElement> {
  late bool isLiked;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post.userLikes.contains(widget.currentUserId);
    likeCount = widget.post.userLikes.length;
  }

  Future<void> _toggleLike() async {
    final url = Uri.parse('http://192.168.43.42:9090/posts/likePost');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'userId': widget.currentUserId,
        'postId': widget.post.id,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        isLiked = !isLiked;
        if (isLiked) {
          widget.post.userLikes.add(widget.currentUserId);
          likeCount++;
        } else {
          widget.post.userLikes.remove(widget.currentUserId);
          likeCount--;
        }
      });
    } else {
      print('Error toggling like status: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
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
            // Post content
            Text(
              widget.post.content,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black87,
                height: 1.4,
              ),
              maxLines: 3, // Limit to 3 lines
              overflow: TextOverflow.ellipsis, // Truncate if too long
            ),
            const SizedBox(height: 12.0),
            // Author and Date information
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Use Flexible to prevent overflow
                Flexible(
                  child: Text(
                    'By: ${widget.post.author.username}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                    overflow: TextOverflow.ellipsis, // Handle overflow
                  ),
                ),
                const SizedBox(width: 8.0),
                Flexible(
                  child: Text(
                    'Posted on: ${formatDate(widget.post.createdAt)}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                    overflow: TextOverflow.ellipsis, // Handle overflow
                  ),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1.0, color: Colors.grey),
            // Like icon, count, and button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                      onPressed: _toggleLike,
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      '$likeCount Likes',
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
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
