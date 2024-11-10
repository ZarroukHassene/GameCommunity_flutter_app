import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:my_blog/bloc/BlogState.dart';
import 'package:my_blog/models/blog_model.dart';


class BlogCubit extends Cubit<BlogState> {
  final String currentUserId;

  BlogCubit({required this.currentUserId}) : super(BlogLoadingState());

  Future<void> loadBlogs() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:5000/api/blogs'));

      if (response.statusCode == 200) {
        final List<dynamic> blogData = json.decode(response.body);
        final blogs = blogData.map((json) => Blog.fromJson(json)).toList();
        emit(BlogLoadedState(blogs));
      } else {
        emit(BlogErrorState("Failed to load blogs"));
      }
    } catch (e) {
      emit(BlogErrorState("An error occurred"));
    }
  }

  Future<void> deleteBlog(String blogId) async {
    try {
      final response = await http.delete(Uri.parse('http://10.0.2.2:5000/api/blogs/$blogId'));

      if (response.statusCode == 200) {
        loadBlogs();
      } else {
        throw Exception('Failed to delete blog');
      }
    } catch (e) {
      print('Error deleting blog: $e');
    }
  }

  Future<void> addBlog(String title, String description) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:5000/api/blogs'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'title': title,
          'description': description,
          'userId': currentUserId,
        }),
      );

      if (response.statusCode == 201) {
        loadBlogs();
      } else {
        throw Exception('Failed to add blog');
      }
    } catch (e) {
      print('Error adding blog: $e');
    }
  }
}
