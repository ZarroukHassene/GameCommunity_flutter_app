import 'package:flutter/material.dart';
import 'package:gamefan_app/pages/HomePage.dart';
import 'package:gamefan_app/pages/blog/BlogScreen.dart';
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
      debugShowCheckedModeBanner: false,
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      // Home page is initially the SignInPage
      home: SignInPage(),
      routes: {
        '/signUp': (context) => SignUpPage(),
        '/SignInPage': (context) => SignInPage(),
        '/ForumHome': (context) => CategoriesListView(),
        '/HomePage': (context) => HomePage(),
        '/Blogs': (context) => BlogScreen(),
      },
    );
  }
}
