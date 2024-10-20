import 'ForumUser.dart';

class Post {
  final String id;
  final String content;
  final DateTime createdAt = DateTime.now();
  final FUser author;

  Post({
    required this.id,
    required this.content,
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
}
