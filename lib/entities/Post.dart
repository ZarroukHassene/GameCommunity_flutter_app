import 'ForumUser.dart';

class Post {
  final String id;
  final String content;
  final DateTime createdAt;
  final FUser author;

  Post({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.author,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author.toJson(),
    };
  }

  @override
  String toString() {
    return 'Post{id: $id, content: $content, author: $author}';
  }
// Factory constructor to create a Post from JSON data
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      author: FUser.fromJson(json['author'] as Map<String, dynamic>),
    );
  }

}
