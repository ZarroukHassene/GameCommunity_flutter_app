import 'package:flutter/material.dart';
import '../../entities/user.dart';

class EditProfilePage extends StatefulWidget {
  final User user;

  EditProfilePage({required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.user.email);
    _usernameController = TextEditingController(text: widget.user.username);
  //  _passwordController = TextEditingController(text: widget.user.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: Icon(Icons.save, size: 30),
            onPressed: () {
              setState(() {
                widget.user.email = _emailController.text;
                widget.user.username = _usernameController.text;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildTextField(_emailController, 'Email', false),
            SizedBox(height: 20),
            _buildTextField(_usernameController, 'Username', false),
            SizedBox(height: 20),
            _buildTextField(_passwordController, 'Password', true),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.user.email = _emailController.text;
                  widget.user.username = _usernameController.text;
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple, // Update this to use backgroundColor
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold , color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool obscureText) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.deepPurple),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        ),
      ),
    );
  }
}
