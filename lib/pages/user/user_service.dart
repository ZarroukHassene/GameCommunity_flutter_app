import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gamefan_app/entities/user.dart';

class UserService {
  final String baseUrl = "http://10.0.2.2:9090";

  // Fetch all users
  Future<List<User>> getUsers() async {
    final url = Uri.parse('$baseUrl/user'); // Adjust this endpoint to match your backend
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((userJson) => User.fromJson(userJson)).toList();
    } else {
      throw Exception("Failed to load users: ${response.statusCode}");
    }
  }

  Future<User> getUserById(String id) async {
    final response = await http.get(Uri.parse("http://10.0.2.2:9090/user/id/$id"));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch user");
    }
  }
  Future<String> getUsername(String id) async{
    User user = await getUserById(id);
    return  user.username;
  }

}
