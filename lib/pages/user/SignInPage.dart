import 'package:flutter/material.dart';
import '../../entities/user.dart';
import 'signUpPage.dart';
import 'showProfilePage.dart'; // Import the Show Profile Page

class SignInPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.png',  // Use your app's logo
                  height: 150,
                  width: 150,
                ),
                SizedBox(height: 40),
                _buildTextField(_emailController, 'Email', false),
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
      onPressed: () {
        String email = _emailController.text;
        String password = _passwordController.text;

        // Navigate to the Show Profile page after sign-in (dummy user for now)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowProfilePage(
              user: User(
                id: '', // Empty ID as placeholder
                username: "User 1",
                email: "User1@example.com",
                password: '123',
              ),
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple, // Use backgroundColor instead of primary
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
        // Navigate to Sign Up Page if the user doesn't have an account
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
