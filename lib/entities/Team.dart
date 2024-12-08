import 'package:gamefan_app/entities/user.dart';  // Ensure this import
import 'package:gamefan_app/pages/user/user_service.dart';

class Team {
  final String id;
  final String? name;
  final String? logo;
  final List<String> memberIds;  // Store member IDs as strings

  Team({
    required this.id,
    this.name,
    this.logo,
    this.memberIds = const [],
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['_id'] as String,
      name: json['name'] as String?,
      logo: json['logo'] as String?,
      memberIds: List<String>.from(json['members'] ?? []),  // Store member IDs as strings
    );
  }
}
