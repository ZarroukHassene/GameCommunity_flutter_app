import 'package:my_blog/models/User.dart';

class Comment {
  final String id;
  final String text;
  final String createdAt;
  final User user;

  Comment({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      createdAt: json['createdAt'],
      user: User.fromJson(json['user']),
    );
  }
}
