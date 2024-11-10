import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Import http package
import 'dart:convert'; // For JSON encoding
import '../../entities/user.dart';
import 'ProfilePage.dart';
import 'package:provider/provider.dart';



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
  }

  Future<void> _updateUser() async {
    final url = Uri.parse('http://10.0.2.2:9090/user/');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        '_id': widget.user.id, // Ensure you have an id property in your User class
        'username': _usernameController.text,
        'email': _emailController.text,
      }),
    );

    if (response.statusCode == 200) {
      String username = _usernameController.text;
      final responsee = await http.get(Uri.parse('http://10.0.2.2:9090/user/find/$username'));

      if (responsee.statusCode == 200) {
        print('Raw Response Body: ${responsee.body}');
        print('Response Headers: ${responsee.headers}');

        // Try parsing the response to confirm it’s JSON
        try {
          final jsonData = json.decode(responsee.body);

          // Verify that jsonData is a map (expected JSON format for User.fromJson)
          if (jsonData is Map<String, dynamic>) {


            // Successfully updated user
            print('User updated successfully!');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(user: User.fromJson(jsonData)),
              ),
            );
          }
        } catch (e) {
          print('Error during JSON decoding or mapping: $e');
          print('Response Body Type: ${responsee.body.runtimeType}');
          throw Exception('Failed to parse user data');
        }
      }
    } else {
      // Handle error
      print('Failed to update user: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update user. Please try again.')),
      );
    }
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
              _updateUser(); // Call the API when save button is pressed
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
            ElevatedButton(
              onPressed: () {
                _updateUser(); // Call the API when save button is pressed
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Save Changes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
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
