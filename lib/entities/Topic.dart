import 'dart:ffi';
import 'ForumUser.dart';

class Topic {
  final String id;
  final String title;
   bool isClosed;
   bool isArchived;
  final FUser author;
  final DateTime createdAt;
  final List<String> postIds = [];

  Topic({
    required this.id,
    required this.title,
    required this.isClosed,
    required this.isArchived,
    required this.author,
    required this.createdAt,
    required List<String> postIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isClosed': isClosed,
      'isArchived': isArchived,
      'author': author.toJson(),
      'postIds': postIds,
    };
  }

  @override
  String toString() {
    return 'Topic{id: $id, title: $title, author: $author, posts: $postIds}';
  }

  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      id: json['_id'] as String? ?? '', // Default to empty string if null
      title: json['title'] as String? ?? 'Untitled Topic',
      author: json['author'] != null
          ? FUser.fromJson(json['author'] as Map<String, dynamic>)
          : FUser(id: '', username: 'Unknown'), // Fallback for null author
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      postIds: (json['posts'] as List<dynamic>?)?.map((e) => e as String).toList() ?? [],
      isClosed: (json['isClosed'] as bool),
      isArchived: (json['isArchived'] as bool),
    );
  }


}

//lib/entities:
//ForumUser.dart => FUser
//Posts.dart => Post
//Topic.dart => Topic
//TopicCategory.dart => TopicCategory

//lib/forum/elements:
//category_element.dart => CategoryElement
//post_element.dart => PostElement
//topic_element.dart => TopicElement

//lib/forum:
//categories_list.dart => CategoriesListView
//posts_list.dart => PostsListView
//topic_details_view.dart => TopicDetailsView