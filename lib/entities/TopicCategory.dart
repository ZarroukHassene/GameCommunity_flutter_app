import 'Topic.dart';

class TopicCategory {
  final String id;
  final String name;
  final DateTime createdAt = DateTime.now();
  final List<Topic> topics;

  TopicCategory({
    required this.id,
    required this.name,
    this.topics = const [],
  });


Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'topics': topics.map((e) => e.toJson()).toList(),
    };
  }


@override
  String toString() {
    return 'TopicCategory{id: $id, name $name, topics: $topics}';
  }
}
