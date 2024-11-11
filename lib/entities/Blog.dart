import 'Comment.dart';

class Blog {
  final String id;
  final String title;
  final String description;
  final String content;
  final String userId;
  final List<Comment> comments;

  Blog({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.userId,
    required this.comments,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      userId: json['user']?['_id'] ?? '',
      comments: (json['comments'] as List<dynamic>?)
          ?.map((comment) => Comment.fromJson(comment))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'content': content,
      'user': userId,
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
