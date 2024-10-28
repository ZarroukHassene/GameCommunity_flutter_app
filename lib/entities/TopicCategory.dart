import 'Topic.dart';

class TopicCategory {
  final String id;
  final String name;
  final DateTime createdAt = DateTime.now();
  final List<String> topicIds = [];

  TopicCategory({
    required this.id,
    required this.name,
    required List<Topic> topicIds,
  });


Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'topics': topicIds,
    };
  }


@override
  String toString() {
    return 'TopicCategory{id: $id, name $name, topics: $topicIds}';
  }

  //From json
  factory TopicCategory.fromJson(Map<String, dynamic> json) {
    return TopicCategory(
      id: json['_id'] as String,
      name: json['name'] as String,
      topicIds: (json['topics'] as List).map((e) => Topic.fromJson(e)).toList(),
    );
  }
}
