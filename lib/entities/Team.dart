import 'user.dart';

class Team {
  final String id;
  final String? name;
  final String? logo;
  final List<String> members; // Store member IDs as strings

  Team({
    required this.id,
    this.name,
    this.logo,
    this.members = const [],
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['_id'] as String,
      name: json['name'] as String?,
      logo: json['logo'] as String?,
      members: json['members'] != null
          ? (json['members'] as List<dynamic>).cast<String>() // Safely handle member IDs
          : [],
    );
  }
}
