import 'package:flutter/material.dart';
import 'package:gamefan_app/pages/user/signInPage.dart';
import 'entities/user.dart';
import 'pages/user/signUpPage.dart';
import 'pages/user/EditProfilePage.dart';
import 'pages/user/ShowProfilePage.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Workshops 5GamiX",
      routes: {
        "/": (BuildContext context) => SignInPage(),
        "/SignUpPage": (BuildContext context) =>  SignUpPage(),
      //  "/SignInPage": (BuildContext context) =>  SignInPage(),
        "/EditProfilePage": (BuildContext context) => EditProfilePage(user: User(id: '',username: "User 1", email: "User1@example.com",  password: '123')),
        "/ShowProfilePage": (BuildContext context) => ShowProfilePage(user: User(id: '',username: "User 1", email: "User1@example.com",  password: '123')),
      },
    );
  }
}
