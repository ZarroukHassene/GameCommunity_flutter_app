import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gamefan_app/entities/Match.dart';
import 'package:gamefan_app/entities/Team.dart';
import 'package:gamefan_app/entities/user.dart';

class MatchPage extends StatelessWidget {
  final Match match;

  const MatchPage({Key? key, required this.match}) : super(key: key);

  Future<User> getUserById(String id) async {
    final response = await http.get(Uri.parse("http://10.0.2.2:9090/user/id/$id"));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to fetch user");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Match Details"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTeamInfo(match.teamA),
                  Column(
                    children: [
                      Text(
                        "${match.date.hour}:${match.date.minute}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${match.date.day}/${match.date.month}/${match.date.year}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  _buildTeamInfo(match.teamB),
                ],
              ),
              const Divider(),
              const SizedBox(height: 16),
              const Text(
                "Lineups",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _buildTeamLineup("Team A", match.teamA.memberIds.cast<String>()),
              const SizedBox(height: 16),
              _buildTeamLineup("Team B", match.teamB.memberIds.cast<String>()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamInfo(Team team) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(team.logo ?? ''),
          onBackgroundImageError: (_, __) => const Icon(Icons.error),
        ),
        const SizedBox(height: 8),
        Text(
          team.name ?? "Unknown",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildTeamLineup(String teamName, List<String> memberIds) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          teamName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        memberIds.isEmpty
            ? const Text("No members in this team")
            : FutureBuilder<List<User>>(
          future: Future.wait(
            memberIds.map((id) => getUserById(id)).toList(),
          ),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text("Error loading users: ${snapshot.error}");
            } else {
              final users = snapshot.data!;
              return Column(
                children: users.map((user) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(width: 8),
                        Text(
                          user.username,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              );
            }
          },
        ),
      ],
    );
  }
}
