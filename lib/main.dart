import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gamefan_app/pages/HomePage.dart';
import 'package:gamefan_app/pages/blog/BlogScreen.dart';
import 'pages/user/signInPage.dart';
import 'pages/user/signUpPage.dart';
import 'forum/categories_list.dart';
import '/pages/ShopPage.dart'; // Correct path to ShopPage
import '/pages/Provider.dart'; // Correct path to Provider.dart


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ProductProvider(), // Initialize ProductProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider(
        create: (context) => ProductProvider()..fetchProducts(),
    child: MaterialApp(

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
    '/ShopPage': (context) => const ShopPage(), // Define the route for ShopPage


      },
    ));
  }
}
