import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:gamefan_app/entities/user.dart'; // Import the User class

class UserProfiles extends StatefulWidget {
  @override
  _UserProfilesState createState() => _UserProfilesState();
}

class _UserProfilesState extends State<UserProfiles> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // Function to fetch users from the API
  Future<void> fetchUsers() async {
    final url = Uri.parse('http://localhost:9090/user');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          users = data.map((userJson) => User.fromJson(userJson)).toList();
        });
      } else {
        print('Failed to load users: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  // Function to change the user's role
  Future<void> changeUserRole(String userId) async {
    final url = Uri.parse('http://localhost:9090/user/changeRole');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'_id': userId}),
      );

      if (response.statusCode == 200) {
        // Refresh the user list after a successful role change
        fetchUsers();
      } else {
        print('Failed to change role: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  // Function to ban the user
  Future<void> BanPlayer(String userId) async {
    final url = Uri.parse('http://localhost:9090/user/banUser');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'_id': userId}),
      );

      if (response.statusCode == 200) {
        // Refresh the user list after banning the user
        fetchUsers();
      } else {
        print('Failed to ban user: ${response.statusCode}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profiles'),
      ),
      body: users.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          User user = users[index];
          return ListTile(
            title: Text(user.username),
            subtitle: Text('Email: ${user.email}\nRole: ${user.role}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    changeUserRole(user.id);
                  },
                  child: Text('Change Role'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    BanPlayer(user.id);
                  },
                  child: Text('Ban Player'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
