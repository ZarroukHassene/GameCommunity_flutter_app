import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/user/signInPage.dart'; // Ensure this is the correct path
import 'entities/user.dart';
import 'pages/user/signUpPage.dart';
import 'pages/user/EditProfilePage.dart';
import 'pages/user/ShowProfilePage.dart'; // Ensure this is the correct path
import 'entities/userModel.dart'; // Import UserModel

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserModel(),
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
      home: SignInPage(), // The entry point of your application
      // Define your routes if necessary
      // routes: {
      //   '/signUp': (context) => SignUpPage(),
      //   '/editProfile': (context) => EditProfilePage(),
      //   '/showProfile': (context) => ShowProfilePage(),
      // },
    );
  }
}
