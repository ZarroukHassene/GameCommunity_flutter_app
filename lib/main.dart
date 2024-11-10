import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/user/signInPage.dart';
import 'pages/user/signUpPage.dart';
import 'pages/user/ProfilePage.dart';
import 'pages/user/EditProfilePage.dart';
import 'pages/user/ShowProfilePage.dart';
import 'entities/userModel.dart';
import 'forum/categories_list.dart'; // Ensure the correct path

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<UserModel>(create: (_) => UserModel()),
      ],
      child: MyApp(),
    ),
  );
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
      },
    );
  }
}
