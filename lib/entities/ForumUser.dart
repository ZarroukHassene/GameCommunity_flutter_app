class FUser {
  final String id;
  final String username;

  FUser({
    required this.id,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {
      'id':
      id,
      'username': username,
    };
  }

  @override
  String toString() {
    return 'FUser{id: $id, username: $username}';
  }

  factory FUser.fromJson(Map<String, dynamic> json) {
    return FUser(
      id: json['_id'] as String? ?? '', // Default to empty string if null
      username: json['username'] as String? ?? 'Anonymous',
    );
  }
}