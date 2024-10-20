import 'ForumUser.dart';
import 'Post.dart';

class Topic {
  final String id;
  final String title;
  final FUser author;
  final DateTime createdAt = DateTime.now();
  final List<Post> posts;

  Topic({
    required this.id,
    required this.title,
    required this.author,
    this.posts = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author.toJson(),
      'posts': posts.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'Topic{id: $id, title: $title, author: $author, posts: $posts}';
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