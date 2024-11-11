import 'package:flutter/material.dart';
import '/services/api_service.dart'; // Adjust import based on your app structure
import 'chat_screen.dart';

class UserListScreen extends StatelessWidget {
  final String currentUserId;

  UserListScreen({required this.currentUserId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: FutureBuilder(
        future: ApiService.getUsers(), // Replace with actual API call
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load users'));
          } else {
            final users = snapshot.data ?? [];
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final userName = user['username'] ?? 'Unknown';
                final userId = user['_id'] ?? '';

                if (userId.isEmpty) {
                  return SizedBox(); // Skip this user if '_id' is null or empty
                }

                return ListTile(
                  title: Text(userName),
                  trailing: ElevatedButton(
                    child: Text('Message'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            currentUserId: currentUserId,
                            otherUserId: userId,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
