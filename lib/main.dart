import 'package:flutter/material.dart';
import 'package:gamefan_app/forum/posts_list.dart';
import 'package:gamefan_app/forum/topics_list.dart';
import 'entities/ForumUser.dart';
import 'entities/Topic.dart';
import 'entities/TopicCategory.dart';
import 'entities/Post.dart';
import 'forum/categories_list.dart';

void main() {
  runApp(GameFanApp());
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

  @override
  void initState() {
    super.initState();
    // Initialize the sample data when the app starts
    initializeSampleData();
  }

  // Function to initialize the sample data
  void initializeSampleData() {
    // Initialize Users
    sampleUsers = [
      FUser(id: 'u1', username: 'alice'),
      FUser(id: 'u2', username: 'bob'),
      FUser(id: 'u3', username: 'charlie'),
      FUser(id: 'u4', username: 'david'),
      FUser(id: 'u5', username: 'eve'),
      FUser(id: 'u6', username: 'frank'),
    ];

    // Initialize Posts
    samplePosts = [
      Post(id: 'p1', content: 'Hello, this is my first post!', author: sampleUsers[0]),
      Post(id: 'p2', content: 'I have a question about the game.', author: sampleUsers[1]),
      Post(id: 'p3', content: 'This forum is great!', author: sampleUsers[2]),
      Post(id: 'p4', content: 'Can someone help me with this area?', author: sampleUsers[3]),
      Post(id: 'p5', content: 'I think we should discuss this further.', author: sampleUsers[4]),
      Post(id: 'p6', content: 'I agree with the previous post.', author: sampleUsers[5]),
      Post(id: 'p7', content: 'Let\'s keep the discussion civil.', author: sampleUsers[0]),
      Post(id: 'p8', content: 'Agreed!', author: sampleUsers[5]),
    ];

    // Initialize Topics
    sampleTopics = [
      Topic(
        id: 't1',
        title: 'Welcome to the GameFan Forum!',
        author: sampleUsers[0],
        posts: [samplePosts[0], samplePosts[2]],
      ),
      Topic(
        id: 't2',
        title: 'What do you guys think about this new DLC?',
        author: sampleUsers[1],
        posts: [samplePosts[1]],
      ),
      Topic(
        id: 't3',
        title: 'Player skills discussion!',
        author: sampleUsers[2],
        posts: [samplePosts[3]],
      ),
      //ADD 10 more topics
      Topic(
        id: 't4',
        title: 'Gameplay mechanics question',
        author: sampleUsers[3],
        posts: [samplePosts[4], samplePosts[5], samplePosts[6], samplePosts[7],
        ],
      ),
      Topic(
        id: 't5',
        title: 'New game announcement!',
        author: sampleUsers[4],
        posts: [samplePosts[0], samplePosts[2], samplePosts[4], samplePosts[6],
        ],
      ),

    ];

    // Initialize Topic Categories
    sampleTopicCategories = [
      TopicCategory(
        id: 'c1',
        name: 'General',
        topics: [sampleTopics[0]],
      ),
      TopicCategory(
        id: 'c2',
        name: 'Programming',
        topics: [sampleTopics[1], sampleTopics[2]],
      ),
      TopicCategory(
        id: 'c3',
        name: 'Gaming',
        topics: [sampleTopics[3], sampleTopics[4]],
      ),

    ];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GameFan Forum',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/forum': (context) => CategoriesListView(categories: sampleTopicCategories, isAdmin: isAdmin),
        '/forum/category': (context) => TopicsListView(category: sampleTopicCategories[0], topics: sampleTopics, isAdmin: isAdmin),
        '/forum/category/topic': (context) => TopicDetailsView(topic: sampleTopics[0]),
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text('GameFan Forum'),
        ),
        body: CategoriesListView(categories: sampleTopicCategories, isAdmin: isAdmin),
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
}

