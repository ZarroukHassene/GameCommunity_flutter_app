import 'ForumUser.dart';
import 'user.dart';

class Topic {
  final String id;
  final String title;
  bool isClosed;
  bool isArchived;
  final User author;
  final DateTime createdAt;
  final List<String> postIds;

  Topic({
    required this.id,
    required this.title,
    required this.isClosed,
    required this.isArchived,
    required this.author,
    required this.createdAt,
    required this.postIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isClosed': isClosed,
      'isArchived': isArchived,
      'author': author.toJson(),
      'postIds': postIds,
    };
  }

  @override
  String toString() {
    return 'Topic{id: $id, title: $title, author: $author, posts: $postIds}';
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['_id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled Topic',
      author: json['author'] != null
          ? User.fromJson(json['author'] as Map<String, dynamic>)
          : User(id: '', username: 'Unknown', email: 'Unknown@gmail.com', role: 'player'),
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      postIds: List<String>.from(json['posts'] ?? []),
      isClosed: json['isClosed'] as bool,
      isArchived: json['isArchived'] as bool,
    );
  }
}
