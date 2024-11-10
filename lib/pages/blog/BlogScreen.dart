import 'package:flutter/material.dart';
import 'package:gamefan_app/pages/blog/BlogDetailsScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<dynamic> blogs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBlogs();
  }

  // Fetch all blogs from the backend
  Future<void> _fetchBlogs() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9090/user/blog/blogs'));

      if (response.statusCode == 200) {
        setState(() {
          blogs = json.decode(response.body);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load blogs');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching blogs: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All Blogs',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)))
          : Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: blogs.length,
          itemBuilder: (context, index) {
            return BlogCard(blog: blogs[index]);
          },
        ),
      ),
    );
  }
}
class BlogCard extends StatelessWidget {
  final dynamic blog;
  const BlogCard({required this.blog});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 5,
      child: InkWell(
        onTap: () {
          // Navigate to the blog details page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlogDetailsScreen(blogId: blog['_id'], ownerId: blog['user']),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog['title'],
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                blog['description'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 12),


            ],
          ),
        ),
      ),
    );
  }
}
