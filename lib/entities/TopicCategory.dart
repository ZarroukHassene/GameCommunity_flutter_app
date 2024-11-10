import 'Topic.dart';

class TopicCategory {
  final String id;
  final String name;
  final DateTime createdAt;
  final List<Topic> topics;

  TopicCategory({
    required this.id,
    required this.name,
    required this.topics,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'topics': topics.map((topic) => topic.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'TopicCategory{id: $id, name $name, topics: $topics}';
  }

  factory TopicCategory.fromJson(Map<String, dynamic> json) {
    return TopicCategory(
      id: json['_id'] as String,
      name: json['name'] as String,
      topics: (json['topics'] as List)
          .map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
