import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gamefan_app/forum/posts_list.dart';
import 'package:gamefan_app/forum/topics_list.dart';
import 'entities/ForumUser.dart';
import 'entities/Topic.dart';
import 'entities/TopicCategory.dart';
import 'entities/Post.dart';
import 'forum/categories_list.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: GameFanApp(),
    ),
  );
}
class UserProvider with ChangeNotifier {
  FUser? _currentUser;

  FUser? get currentUser => _currentUser;

  void setUser(FUser user) {
    _currentUser = user;
    notifyListeners();
  }
}

class GameFanApp extends StatefulWidget {
  @override
  _GameFanAppState createState() => _GameFanAppState();
}
class _GameFanAppState extends State<GameFanApp> {
  // A variable to switch between admin and user mode
  bool isAdmin = true;

  // First, declare the lists without initializing them
  List<FUser> sampleUsers = [];
  List<Post> samplePosts = [];
  List<Topic> sampleTopics = [];
  List<TopicCategory> sampleTopicCategories = [];
  FUser currentUser = FUser(id: '671ec40066de43881f2b6c53', username: 'hassen');
  //final userProvider = Provider.of<UserProvider>(context);
  @override
  void initState() {
    super.initState();
    //_getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameFan Forum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/forum': (context) => CategoriesListView( isAdmin: isAdmin),
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text('GameFan Forum'),
        ),
        body: CategoriesListView( isAdmin: isAdmin),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              // Toggle admin and user mode for testing
              isAdmin = !isAdmin;
            });
          },
          child: Icon(Icons.swap_horiz),
          tooltip: isAdmin ? 'Switch to User Mode' : 'Switch to Admin Mode',
          heroTag: 'toggleAdminModeFAB',
        ),
      ),
    );
  }

  Future<void> _getCurrentUser() async
  {

    ///Get current user by query /users/hassen
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:9090/users/hassen'));
      if (response.statusCode == 200) {
        final userJson = json.decode(response.body);
        FUser currentUser= FUser(
              id: userJson['_id'],
              username: userJson['username'],
        );
        print(currentUser.toString());
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      print('Error fetching user: $e');
      currentUser= FUser(id: 'u1', username: 'alice');
    }
}


}

