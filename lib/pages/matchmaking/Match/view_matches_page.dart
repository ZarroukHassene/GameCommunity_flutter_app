import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'match_service.dart';
import 'package:gamefan_app/entities/Match.dart';
import 'package:gamefan_app/entities/Team.dart';
import 'match_page.dart';

class ViewMatchesPage extends StatefulWidget {
  const ViewMatchesPage({Key? key}) : super(key: key);

  @override
  State<ViewMatchesPage> createState() => _ViewMatchesPageState();
}

class _ViewMatchesPageState extends State<ViewMatchesPage> {
  final MatchService matchService = MatchService();
  List<Match> matches = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchMatches();
  }

  Future<void> fetchMatches() async {
    try {
      final fetchedMatches = await matchService.getMatches();
      print("Fetched matches: $fetchedMatches"); // Debug: Log raw response
      setState(() {
        matches = fetchedMatches;
        isLoading = false;
      });
    } catch (e) {
      print("Error: $e"); // Debug: Log error
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load matches: $e")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Matches"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : matches.isEmpty
          ? const Center(child: Text("No matches available"))
          : ListView.builder(
        itemCount: matches.length,
        itemBuilder: (context, index) {
          final match = matches[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MatchPage(match: match),
                ),
              );
            },
            child: _buildMatchCard(match),
          );
        },
      ),
    );
  }

  Widget _buildMatchCard(Match match) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
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
                      DateFormat('HH:mm').format(match.date),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(match.date),
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
          ],
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
}
