import 'dart:convert'; // For JSON decoding
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gamefan_app/pages/matchmaking/Team/TeamService.dart';
import 'package:gamefan_app/pages/user/user_service.dart';
import 'package:gamefan_app/entities/user.dart';

class AddMemberPage extends StatefulWidget {
  final String teamId;

  const AddMemberPage({Key? key, required this.teamId}) : super(key: key);

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final TeamService teamService = TeamService();
  final UserService userService = UserService();

  List<User> users = []; // List of all users who can be added
  List<User> teamMembers = []; // Current members of the team
  User? selectedUser; // Dropdown selected user
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsersAndMembers();
  }

  // Fetch users and team members
  void fetchUsersAndMembers() async {
    try {
      // Fetch all users and teams
      final fetchedUsers = await userService.getUsers();
      final fetchedTeam = await teamService.getTeamById(widget.teamId);
      final allTeams = await teamService.getTeams();

      // Collect all user IDs already in other teams
      final Set<String> usersInTeams = allTeams.expand((team) {
        return team.members.map((member) {
          if (member is String) {
            return member; // If member is a String ID, return it directly
          } else {
            throw Exception("Unexpected member type: ${member.runtimeType}");
          }
        });
      }).toSet();

      // Parse `fetchedTeam.members` into List<User>
      final List<User> teamMembersList = (fetchedTeam.members as List<dynamic>).map((member) {
        if (member is Map<String, dynamic>) {
          return User.fromJson(member); // Convert JSON to User
        } else {
          throw Exception("Unexpected member type: ${member.runtimeType}");
        }
      }).toList();

      // Exclude users already in teams
      setState(() {
        users = fetchedUsers.where((user) => !usersInTeams.contains(user.id)).toList();
        teamMembers = teamMembersList;
        isLoading = false;
      });

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load data: $e")),
      );
    }
  }

  // Add a member to the team
  void addMember() async {
    if (selectedUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a user to add")),
      );
      return;
    }

    if (teamMembers.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Team already has the maximum number of members (5).")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await teamService.addMemberToTeam(widget.teamId, selectedUser!.id);

      setState(() {
        teamMembers.add(selectedUser!);
        users.remove(selectedUser!); // Remove the added user from the dropdown
        selectedUser = null; // Clear the selection
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Member added successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add member: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Remove a member from the team
  void removeMember(User user) async {
    setState(() {
      isLoading = true;
    });

    try {
      await teamService.removeMemberFromTeam(widget.teamId, user.id);

      setState(() {
        teamMembers.remove(user);
        users.add(user); // Add the removed user back to the dropdown
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Member removed successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to remove member: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Team Members"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display team members
            const Text(
              "Team Members",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            teamMembers.isEmpty
                ? const Text("No members in the team yet")
                : ListView.builder(
              shrinkWrap: true, // Wrap content
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(member.username[0].toUpperCase()),
                  ),
                  title: Text(member.username),
                  subtitle: Text(member.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove_circle),
                    color: Colors.red,
                    onPressed: () {
                      removeMember(member);
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Add Member Section
            teamMembers.length >= 5
                ? const Text(
              "Maximum members reached. You can't add more members.",
              style: TextStyle(color: Colors.red, fontSize: 16),
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add Member",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                DropdownButton<User>(
                  value: selectedUser,
                  hint: const Text("Select a user"),
                  isExpanded: true,
                  items: users.map((user) {
                    return DropdownMenuItem<User>(
                      value: user,
                      child: Text(user.username),
                    );
                  }).toList(),
                  onChanged: (User? newValue) {
                    setState(() {
                      selectedUser = newValue;
                    });
                  },
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: addMember,
                  child: const Text("Add Member"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
