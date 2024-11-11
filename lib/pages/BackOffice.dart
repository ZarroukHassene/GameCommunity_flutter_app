import 'package:flutter/material.dart';
import 'package:gamefan_app/pages/user/ProfilePage.dart';
import 'package:gamefan_app/pages/user/UserProfiles.dart';
import 'package:gamefan_app/pages/user/SignInPage.dart';
import '../entities/user.dart';
import 'ShopPage.dart';

class BackOffice extends StatefulWidget {
  BackOffice({Key? key}) : super(key: key);

  @override
  _BackOfficeState createState() => _BackOfficeState();
}

class _BackOfficeState extends State<BackOffice> {
  late User? newUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      newUser = await User.claimCurrentUser();
    } catch (error) {
      print('Error retrieving user: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Back Office'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.red,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                if (isLoading) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Loading user data...')),
                  );
                } else if (newUser == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No user found')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(user: newUser!),
                    ),
                  );
                }
              },
            ),


            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shop'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopPage()),
                );
              },
            ),

            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                User.logout(); // Call the logout method from user.dart
                Navigator.push(
                  context,

                  MaterialPageRoute(builder: (context) => SignInPage()),
                );
                },
            ),
          ],
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _buildGridButton(
              context,
              icon: Icons.person,
              label: 'Profile',
              onTap: () {
                if (newUser == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No user found')),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfiles(),
                    ),
                  );
                }
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.forum,
              label: 'Forum',
              onTap: () {
                Navigator.pushNamed(context, '/ForumHome');
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.shopping_cart,
              label: 'Shop',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ShopPage()),
                );
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.article,
              label: 'Blog',
              onTap: () {
                Navigator.pushNamed(context, '/Blogs');  // Fixed: Using named route
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildGridButton(BuildContext context,
      {required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 6.0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48.0, color: Colors.white),
            const SizedBox(height: 8.0),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
