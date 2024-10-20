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
}