import 'package:flutter/material.dart';
import 'package:gamefan_app/pages/matchmaking/Team/TeamService.dart';
import 'package:gamefan_app/pages/user/user_service.dart';
import 'package:gamefan_app/entities/Team.dart';
import 'add_member_page.dart';
import 'create_team_page.dart';
import 'package:gamefan_app/entities/user.dart';

class ViewTeamsPage extends StatefulWidget {
  const ViewTeamsPage({Key? key}) : super(key: key);

  @override
  State<ViewTeamsPage> createState() => _ViewTeamsPageState();
}

class _ViewTeamsPageState extends State<ViewTeamsPage> {
  final TeamService teamService = TeamService();
  final UserService userService = UserService();
  List<Team> teams = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  // Fetch all teams from the backend
  void fetchTeams() async {
    try {
      final fetchedTeams = await teamService.getTeams();
      List<Team> teamsWithMembers = [];

      for (var team in fetchedTeams) {
        List<User> teamUsers = [];

        // Fetch users for each member ID in the team
        for (var memberId in team.memberIds) {
          try {
            final user = await userService.getUserById(memberId);  // Fetch full User data
            teamUsers.add(user);  // Add User to the list of members
          } catch (e) {
            print("Error fetching user for member ID: $memberId");
          }
        }

        // Add the team with full User objects for members
        setState(() {
          teamsWithMembers.add(Team(
            id: team.id,
            name: team.name,
            logo: team.logo,
            memberIds: [],  // Empty the memberIds since we've already fetched the full User objects
            //members: teamUsers,  // Add full User objects for each member
          ));
        });
      }

      setState(() {
        teams = teamsWithMembers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load teams: $e")),
      );
    }
  }

  // Delete a team
  void deleteTeam(String teamId) async {
    setState(() {
      isLoading = true;
    });

    try {
      await teamService.deleteTeam(teamId);

      // Remove the deleted team from the list
      setState(() {
        teams.removeWhere((team) => team.id == teamId);
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Team deleted successfully!")));
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete team: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Teams"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : teams.isEmpty
          ? const Center(child: Text("No teams available"))
          : ListView.builder(
        itemCount: teams.length,
        itemBuilder: (context, index) {
          final team = teams[index];
          return Card(
            margin: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 4),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: team.logo != null && team.logo!.isNotEmpty
                    ? NetworkImage(team.logo!)
                    : const AssetImage('assets/default_logo.png') as ImageProvider,
                onBackgroundImageError: (_, __) => const Icon(Icons.error),
              ),
              title: Text(team.name.toString()),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Display each member's username
                  ...team.memberIds.map((user) {
                    return Text(userService.getUsername(user) as String, style: const TextStyle(fontSize: 14));
                  }).toList(),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.group_add),
                    color: Colors.green,
                    onPressed: () {
                      // Navigate to AddMemberPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddMemberPage(teamId: team.id),
                        ),
                      );
                    },
                    tooltip: "Add Members",
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      // Show confirmation dialog before deleting the team
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Confirm Deletion"),
                          content: const Text("Are you sure you want to delete this team?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                deleteTeam(team.id);
                              },
                              child: const Text("Delete"),
                            ),
                          ],
                        ),
                      );
                    },
                    tooltip: "Delete Team",
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to CreateTeamPage
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateTeamPage(),
            ),
          ).then((value) {
            // Refresh the list of teams when coming back
            fetchTeams();
          });
        },
        child: const Icon(Icons.add),
        tooltip: "Create a New Team",
      ),
    );
  }
}
