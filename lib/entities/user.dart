class User {
  final String id;
  late final String email;
  late final String username;
  final String password;

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
  });

  // Convert a User object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'password': password,
    };
  }

  // Create a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      password: map['password'],
    );
  }
}
