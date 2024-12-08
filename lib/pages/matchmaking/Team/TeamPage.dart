import 'package:flutter/material.dart';
import 'package:gamefan_app/entities/Team.dart';
import 'package:gamefan_app/pages/matchmaking/Team/TeamService.dart';

class TeamPage extends StatelessWidget {
  final Team team;

  const TeamPage({Key? key, required this.team}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Team Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Team Logo
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(team.logo.toString()),
              onBackgroundImageError: (_, __) => const Icon(Icons.error),
            ),
            const SizedBox(height: 20),
            // Team Name
            Text(
              team.name.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            // Members Section
            const Text(
              "Team Members",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            // Members Display
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, // 3 items per row
                  childAspectRatio: 1, // Make square tiles
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: team.members.length,
                itemBuilder: (context, index) {
                  final member = team.members[index];
                  return Column(
                    children: [
                      // Placeholder Avatar for member
                      const CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person),
                      ),
                      const SizedBox(height: 5),
                      // Member Name
                      Text(
                        member.toString(),
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
