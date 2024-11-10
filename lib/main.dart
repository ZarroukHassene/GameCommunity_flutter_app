import 'package:flutter/material.dart';
import 'package:gamefan_app/pages/HomePage.dart';
import 'entities/user.dart';
import 'pages/user/signInPage.dart';
import 'pages/user/signUpPage.dart';
import 'forum/categories_list.dart'; // Ensure the correct path

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      // Home page can be the SignInPage since it's the entry point
      home: SignInPage(),
      routes: {
        '/signUp': (context) => SignUpPage(),
    '/ForumHome': (context) => CategoriesListView(),
        '/HomePage': (context) => HomePage(),
      },
    );
  }
}
