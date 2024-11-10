import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_blog/bloc/blog_bloc.dart';
import 'package:my_blog/screens/HomePageScreen.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlogCubit(currentUserId: "user123"),  // Replace with actual user ID
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Blog',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
