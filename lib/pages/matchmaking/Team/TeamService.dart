import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:gamefan_app/entities/Team.dart';

class TeamService {
  final String baseUrl = "http://10.0.2.2:9090";

  // // Create a new team
  // Future<Team> createTeam(String name, String logo) async {
  //   final url = Uri.parse('$baseUrl/team');
  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"name": name, "logo": logo}),
  //     );
  //
  //     if (response.statusCode == 201 || response.statusCode == 200) {
  //       return Team.fromJson(jsonDecode(response.body));
  //     } else {
  //       throw Exception("Failed to create team: ${response.statusCode}");
  //     }
  //   } catch (e) {
  //     throw Exception("Failed to connect to the server: $e");
  //   }
  // }


  // Fetch all teams
  Future<List<Team>> getTeams() async {
    final url = Uri.parse('$baseUrl/team');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((teamJson) => Team.fromJson(teamJson)).toList();
    } else {
      throw Exception("Failed to load teamsAAAAAAA: ${response.statusCode}");
    }
  }

  // Delete a team by ID
  Future<void> deleteTeam(String teamId) async {
    final url = Uri.parse('$baseUrl/team/$teamId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to delete team: ${response.statusCode}");
    }
  }

  // Fetch a single team by ID
  Future<Team> getTeamById(String teamId) async {
    final url = Uri.parse('$baseUrl/team/$teamId');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return Team.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to fetch team: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to connect to the server: $e");
    }
  }

  // Update a team
  Future<Team> updateTeam(String teamId, String name, String logo) async {
    final url = Uri.parse('$baseUrl/team/$teamId');
    try {
      final response = await http.put(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"name": name, "logo": logo}),
      );

      if (response.statusCode == 200) {
        return Team.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Failed to update team: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Failed to connect to the server: $e");
    }
  }

  // Add a member to a team
  Future<void> addMemberToTeam(String teamId, String userId) async {
    final url = Uri.parse('$baseUrl/team/addMember');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "teamId": teamId,
        "userId": userId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to add member: ${response.statusCode}");
    }
  }
  // Remove a member from a team
  Future<void> removeMemberFromTeam(String teamId, String userId) async {
    final url = Uri.parse('$baseUrl/team/removeMember');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "teamId": teamId,
        "userId": userId,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to remove member: ${response.statusCode}");
    }
  }

  Future<void> createTeamWithImage(String name, File logo) async {
    final url = Uri.parse('$baseUrl/team');
    final request = http.MultipartRequest('POST', url);

    request.fields['name'] = name; // Add team name
    request.files.add(
      await http.MultipartFile.fromPath(
        'logo', // Match this with the field name expected by the API
        logo.path,
      ),
    );

    final response = await request.send();

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Failed to create team: ${response.statusCode}");
    }
  }

  // Upload the image and get the URL
  // Upload the image and get the URL
  Future<String> uploadImage(File image) async {
    final url = Uri.parse('$baseUrl/upload'); // Correct the upload endpoint if needed
    final request = http.MultipartRequest('POST', url);

    request.files.add(
      await http.MultipartFile.fromPath('image', image.path),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await http.Response.fromStream(response);
      final data = jsonDecode(responseData.body);
      return data['imageUrl']; // Return the image URL
    } else if (response.statusCode == 404) {
      throw Exception("Upload endpoint not found: ${response.statusCode}");
    } else {
      throw Exception("Failed to upload image: ${response.statusCode}");
    }
  }

  // Create a team with name and logo URL
  Future<void> createTeam(String name, String imageUrl) async {
    final url = Uri.parse('$baseUrl/team');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "logo": imageUrl,
      }),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception("Failed to create team: ${response.statusCode}");
    }
  }
}
