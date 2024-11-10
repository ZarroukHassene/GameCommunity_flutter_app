class User {
  final String id;
  late final String email;
  late final String username;

  User({
    required this.id,
    required this.email,
    required this.username,
  });

  // Convert a User object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
    };
  }

  // Create a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
    );
  }

factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String? ?? '', // Default to empty string if null
      email: json['email'] as String? ?? 'Anonymous',
      username: json['username'] as String? ?? 'Anonymous',
    );
  }

  //FromJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, username: $username}';
  }
}
