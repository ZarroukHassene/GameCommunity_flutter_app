import 'package:flutter/material.dart';
import '../../entities/user.dart';
import 'EditProfilePage.dart';

class ShowProfilePage extends StatelessWidget {
  final User user;

  ShowProfilePage({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.bold , color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, size: 30),
            onPressed: () {
              // Navigate to the Edit Profile page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfilePage(user: user),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            SizedBox(height: 20),
            _buildProfileInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.blueAccent,
            child: Text(
              user.username[0].toUpperCase(),
              style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 10),
          Text(
            user.username,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileRow(Icons.email, 'Email', user.email),
            Divider(),
            _buildProfileRow(Icons.lock, 'Password', '********'),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileRow(IconData icon, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      ],
    );
  }
}
