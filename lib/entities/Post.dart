import 'user.dart';


class Post {
  final String id;
  final String content;
  final DateTime createdAt;
  final User author;
  final List<String> userLikes;

  Post({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.author,
    required this.userLikes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'author': author.toJson(),
      'userLikes': userLikes,
    };
  }

  @override
  String toString() {
    return 'Post{id: $id, content: $content, author: $author, userLikes: $userLikes}';
  }

  // Factory constructor to create a Post from JSON data
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      author: User.fromJson(json['author'] as Map<String, dynamic>),
      userLikes: json['userLikes'] != null
          ? List<String>.from(json['userLikes'] as Iterable<dynamic>)
          : [],
    );
  }
}