import 'package:flutter/material.dart';
import 'package:gamefan_app/entities/user.dart'; // Ensure this import is correct
import 'package:provider/provider.dart';
class ShowProfilePage extends StatelessWidget {
  final User user;

  // Constructor to accept the User object
  ShowProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile of ${user.username}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('User ID: ${user.id}'),
            Text('Username: ${user.username}'),
            Text('Email: ${user.email}'),
          ],
        ),
      ),
    );
  }
}