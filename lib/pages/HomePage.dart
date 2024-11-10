import 'package:flutter/material.dart';
 // Import CategoriesListView

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
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
                color: Colors.blue,
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
                // Placeholder for profile route
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.forum),
              title: Text('Forum'),
              onTap: () {
                Navigator.pushNamed(context, '/ForumHome');
              },
            ),
            ListTile(
              leading: Icon(Icons.article),
              title: Text('Blog'),
              onTap: () {
                // Placeholder for blog route
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_cart),
              title: Text('Shop'),
              onTap: () {
                // Placeholder for shop route
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.sports_esports),
              title: Text('Matches'),
              onTap: () {
                // Placeholder for matches route
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.help),
              title: Text('Assistance'),
              onTap: () {
                // Placeholder for assistance route
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Padding(
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
                // Placeholder for profile route
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
              icon: Icons.article,
              label: 'Blog',
              onTap: () {
                // Placeholder for blog route
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.shopping_cart,
              label: 'Shop',
              onTap: () {
                // Placeholder for shop route
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.sports_esports,
              label: 'Matches',
              onTap: () {
                // Placeholder for matches route
              },
            ),
            _buildGridButton(
              context,
              icon: Icons.help,
              label: 'Assistance',
              onTap: () {
                // Placeholder for assistance route
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
          color: Colors.blueAccent,
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
