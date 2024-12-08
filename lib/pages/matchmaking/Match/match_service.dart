import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:gamefan_app/entities/Match.dart';

class MatchService {
  final String baseUrl = "http://10.0.2.2:9090";

  // Fetch all matches
  // Fetch all matches
  Future<List<Match>> getMatches() async {
    final url = Uri.parse('$baseUrl/match');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((matchJson) => Match.fromJson(matchJson)).toList();
    } else {
      throw Exception("Failed to load matches: ${response.statusCode}");
    }
  }


  // Create a new match
  Future<void> createMatch(String teamA, String teamB, String date) async {
    final url = Uri.parse('$baseUrl/match');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "teamA": teamA,
        "teamB": teamB,
        "date": date,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Failed to create match: ${response.statusCode}");
    }
  }

  Future<void> deleteMatch(String matchId) async {
    final url = Uri.parse('$baseUrl/match/$matchId');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to delete match: ${response.statusCode}");
    }
  }
}
