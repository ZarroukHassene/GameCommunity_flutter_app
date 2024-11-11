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
    final user = json['user'] ?? {}; // Ensure 'user' is retrieved from the response
    return Comment(
      id: json['_id'] ?? '',
      userId: user['_id'] ?? '',
      username: user['username'] ?? 'Unknown user',
      commentText: json['text'] ?? '', // Make sure this matches the backend comment field
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': {'_id': userId, 'username': username},
      'text': commentText, // Make sure this matches the backend comment field
    };
  }
}
