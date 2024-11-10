import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gamefan_app/entities/user.dart';
import 'package:gamefan_app/entities/userModel.dart'; // Make sure the import is correct
import 'showProfilePage.dart';
import 'signUpPage.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 40),
                _buildTextField(_usernameController, 'Username', false),
                SizedBox(height: 20),
                _buildTextField(_passwordController, 'Password', true),
                SizedBox(height: 40),
                _buildSignInButton(context),
                SizedBox(height: 20),
                _buildSignUpPrompt(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, bool obscureText) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.2),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(fontSize: 16),
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
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String username = _usernameController.text;
        String password = _passwordController.text;

        final url = Uri.parse('http://10.0.2.2:9090/user/login');

        try {
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'username': username,
              'password': password,
            }),
          );

          if (response.statusCode == 200) {
            final responseBody = jsonDecode(response.body);
            print('Response body parsed: $responseBody');

            User newUser = User(
              id: responseBody['_id'],
              username: responseBody['username'],
              email: responseBody['email'],
              // password: password, // Not safe to store passwords
            );
            print('Response 123: $newUser');

            // Access UserModel using Consumer or directly with context
            final userModel = Provider.of<UserModel>(context, listen: false);
            userModel.login(newUser);

            final currentUser = userModel.currentUser;
            if (currentUser != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShowProfilePage(user: currentUser)),
              );
            } else {
              print('User is not logged in.');
            }
          } else {
            print('Failed to log in: ${response.body}');
          }
        } catch (error) {
          print('Error occurred: $error');
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 5,
      ),
      child: Text(
        'Sign In',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildSignUpPrompt(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUpPage()),
        );
      },
      child: Text(
        'Don\'t have an account? Sign Up',
        style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold),
      ),
    );
  }
}
