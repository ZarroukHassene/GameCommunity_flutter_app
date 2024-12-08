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
      memberIds: json['members'] is List
          ? List<String>.from(json['members'].map((member) {
        if (member is String) {
          // Member is already an ID string
          return member;
        } else if (member is Map<String, dynamic> && member['_id'] is String) {
          // Member is an object with an "_id" field
          return member['_id'] as String;
        } else {
          throw Exception("Invalid member format: $member");
        }
      }))
          : [],
    );
  }


}
