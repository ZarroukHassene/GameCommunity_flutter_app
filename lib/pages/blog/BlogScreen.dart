import 'package:flutter/material.dart';
import 'package:gamefan_app/pages/blog/BlogDetailsScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../entities/user.dart';
import 'addBlog.dart';

class BlogScreen extends StatefulWidget {
  @override
  _BlogScreenState createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  List<dynamic> blogs = [];
  bool isLoading = true;
  bool isAdmin = false; // Track if the user is an admin
  late User user;

  @override
  void initState() {
    super.initState();
    loadUserData(); // Load user data to determine role
    _fetchBlogs();
  }

  // Fetch all blogs from the backend
  // Fetch all blogs from the backend
  Future<void> _fetchBlogs() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.43.42:9090/user/blog/blogz'));

      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        print("Blogs data fetched: $decodedData"); // Debugging statement to inspect response
        setState(() {
          blogs = decodedData; // Assuming `decodedData` is a list of blog objects
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


  // Load the current user to check if they are an admin
  Future<void> loadUserData() async {
    try {
      user = (await User.claimCurrentUser())!;
      setState(() {
        isAdmin = user.role == "admin";
      });
    } catch (error) {
      print('Error retrieving user: $error');
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
      floatingActionButton: isAdmin
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BlogAddScreen()),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
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
              builder: (context) => BlogDetailsScreen(
                blogId: blog['_id'] ?? '',       // Correctly accessing blog ID
 // Correctly accessing owner ID from `user`
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                blog['title'] ?? 'No Title', // Provide a default title if 'title' is null
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              SizedBox(height: 8),
              Text(
                blog['description'] ?? 'No Description', // Default description if 'description' is null
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
