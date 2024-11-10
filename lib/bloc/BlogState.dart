import 'package:my_blog/models/blog_model.dart';



abstract class BlogState {}

class BlogLoadingState extends BlogState {}

class BlogLoadedState extends BlogState {
  final List<Blog> blogs;

  BlogLoadedState(this.blogs);
}

class BlogErrorState extends BlogState {
  final String message;

  BlogErrorState(this.message);
}
