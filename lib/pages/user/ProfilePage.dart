import 'package:flutter/material.dart';
import 'package:gamefan_app/entities/user.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile of ${user.username}'),
        actions: [
          IconButton(
            icon: Icon(Icons.forum),
            onPressed: () {
              Navigator.pushNamed(context, '/ForumHome');
            },
          ),
        ],
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
