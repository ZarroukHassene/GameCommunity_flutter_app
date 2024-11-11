class Comment {
  final String id;
  final String userId;
  final String username;
  final String commentText;

  Comment({
    required this.id,
    required this.userId,
    required this.username,
    required this.commentText,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'] ?? '',
      userId: json['user']['_id'] ?? '',
      username: json['user']['username'] ?? 'Unknown user',
      commentText: json['comment'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': {'_id': userId, 'username': username},
      'comment': commentText,
    };
  }
}
