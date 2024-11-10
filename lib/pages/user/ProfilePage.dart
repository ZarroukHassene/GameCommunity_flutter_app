import 'package:flutter/material.dart';
import 'package:gamefan_app/entities/user.dart';
import 'package:provider/provider.dart';
import 'EditProfilePage.dart';
import 'SignInPage.dart';

class ProfilePage extends StatelessWidget {
  User user;

  ProfilePage({Key? key, required this.user}) : super(key: key);

  Future<void> loadUserData() async {
    try {
       user = (await User.claimCurrentUser())!; // Await the Future
    } catch (error) {
      print('Error retrieving user: $error');
    }
  }
  @override
  Widget build(BuildContext context) {

print("AAAAAAAAAAAAAAA " + user.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile of ${user.username}', style: TextStyle(fontWeight: FontWeight.bold)),

        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: false, // Disable the back button
        actions: [
          IconButton(
            icon: Icon(Icons.forum),
            onPressed: () {
              Navigator.pushNamed(context, '/ForumHome');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Picture
            Center(
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.deepPurple,
                child: Icon(
                  Icons.person,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 20),

            // Username Section
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              child: ListTile(
                title: Text(
                  'Username',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                subtitle: Text(
                  user.username,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            // Email Section
            Card(
              margin: EdgeInsets.symmetric(vertical: 10),
              elevation: 5,
              child: ListTile(
                title: Text(
                  'Email',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                ),
                subtitle: Text(
                  user.email,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),

            // User ID Section

            // Edit Profile Button
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditProfilePage(user: user)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Button color
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Edit Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),

            // Log Out Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button color for logout
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Log Out',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
