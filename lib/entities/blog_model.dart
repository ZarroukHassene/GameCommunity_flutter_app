import 'user.dart';
import 'comment.dart';


class Blog {
  final String id;
  final String title;
  final String description;
  final User user;
  final List<Comment> comments;

  Blog({
    required this.id,
    required this.title,
    required this.description,
    required this.user,
    required this.comments,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      user: User.fromJson(json['user']),
      comments: (json['comments'] as List)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
    );
  }
}