import 'package:shared_preferences/shared_preferences.dart';

// User class
class User {
  final String id;
  final String email;
  final String username;
  final String role; // New role property

  User({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
  });

  // Convert a User object into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'role': role,
    };
  }

  // Create a User object from a Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      email: map['email'],
      username: map['username'],
      role: map['role'] ?? 'player', // Default role to "player" if not provided
    );
  }

  // Create a User object from JSON data
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String? ?? '', // Default to empty string if null
      email: json['email'] as String? ?? 'Anonymous',
      username: json['username'] as String? ?? 'Anonymous',
      role: json['role'] as String? ?? 'player', // Default to "player" if null
    );
  }

  // Convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'username': username,
      'role': role,
    };
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, username: $username, role: $role}';
  }

  // Save user to SharedPreferences
  static Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('user_id', user.id);
    prefs.setString('user_email', user.email);
    prefs.setString('user_username', user.username);
    prefs.setString('user_role', user.role); // Save role to SharedPreferences
  }

  // Claim the current user from SharedPreferences
  static Future<User?> claimCurrentUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the stored user data
    String? id = prefs.getString('user_id');
    String? email = prefs.getString('user_email');
    String? username = prefs.getString('user_username');
    String? role = prefs.getString('user_role') ?? 'player'; // Default to "player"

    if (id == null || email == null || username == null) {
      return null; // No user data found
    }

    return User(
      id: id,
      email: email,
      username: username,
      role: role,
    );
  }

  // Logout by removing user data from SharedPreferences
  static Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the user data keys
    await prefs.remove('user_id');
    await prefs.remove('user_email');
    await prefs.remove('user_username');
    await prefs.remove('user_role'); // Remove role from SharedPreferences
  }
}
