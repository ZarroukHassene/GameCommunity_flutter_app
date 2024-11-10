abstract class BlogEvent {}

class LoadBlogsEvent extends BlogEvent {}

class AddBlogEvent extends BlogEvent {
  final String title;
  final String description;
  final String userId;

  AddBlogEvent({
    required this.title,
    required this.description,
    required this.userId,
  });
}

class DeleteBlogEvent extends BlogEvent {
  final String blogId;

  DeleteBlogEvent(this.blogId);
}
