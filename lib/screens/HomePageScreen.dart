import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_blog/BlogCard.dart';
import 'package:my_blog/bloc/BlogState.dart';
import 'package:my_blog/bloc/blog_bloc.dart';
import 'package:my_blog/screens/addBlog.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Blogs'),
      ),
      body: BlocBuilder<BlogCubit, BlogState>(
        builder: (context, state) {
          if (state is BlogLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BlogErrorState) {
            return Center(child: Text(state.message));
          } else if (state is BlogLoadedState) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                return BlogCard(
                  blog: state.blogs[index],
                  onDelete: (blogId) {
                    BlocProvider.of<BlogCubit>(context).deleteBlog(blogId);
                  },
                  currentUserId: BlocProvider.of<BlogCubit>(context).currentUserId,
                );
              },
            );
          } else {
            return const Center(child: Text("Unknown state"));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BlogAddScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
