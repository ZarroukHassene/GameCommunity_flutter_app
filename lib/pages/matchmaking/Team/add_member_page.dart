import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gamefan_app/entities/user.dart';
import 'package:gamefan_app/pages/matchmaking/Team/TeamService.dart';
import 'package:gamefan_app/pages/user/user_service.dart';

import '../../../entities/Team.dart';

class AddMemberPage extends StatefulWidget {
  final String teamId;

  const AddMemberPage({Key? key, required this.teamId}) : super(key: key);

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  final TeamService teamService = TeamService();
  final UserService userService = UserService();

  List<User> users = [];
  List<User> teamMembers = [];
  User? selectedUser;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsersAndMembers();
  }

  // Fetch users and team members
  void fetchUsersAndMembers() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch users
      List<User> fetchedUsers = [];
      try {
        fetchedUsers = await userService.getUsers();
        if (fetchedUsers.isEmpty) {
          debugPrint("No users found.");
        }
      } catch (e) {
        debugPrint("Error fetching users: $e");
        throw Exception("Error fetching users: $e");
      }

      // Fetch team details
      Team? fetchedTeam;
      try {
        fetchedTeam = await teamService.getTeamById(widget.teamId);
        if (fetchedTeam == null) {
          debugPrint("Team not found.");
          throw Exception("Team not found.");
        }
      } catch (e) {
        debugPrint("Error fetching team: $e");
        throw Exception("Error fetching team: $e");
      }

      // Parse members
      List<User> membersDetails = [];
      try {
        for (var memberId in fetchedTeam.memberIds) {
          try {
            final member = await userService.getUserById(memberId);
            if (member == null) {
              debugPrint("Member with ID $memberId not found.");
            } else {
              membersDetails.add(member);
            }
          } catch (e) {
            debugPrint("Error fetching member with ID $memberId: $e");
          }
        }
      } catch (e) {
        debugPrint("Error parsing team members: $e");
        throw Exception("Error parsing team members: $e");
      }

      // Update state
      setState(() {
        teamMembers = membersDetails;
        users = fetchedUsers
            .where((user) => !fetchedTeam!.memberIds.contains(user.id.toString()))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error in fetchUsersAndMembers: $e");
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

    setState(() {
      isLoading = true;
    });

    try {
      await teamService.addMemberToTeam(widget.teamId, selectedUser!.id);
      setState(() {
        teamMembers.add(selectedUser!); // Add selected user to team members
        users.remove(selectedUser); // Remove the selected user from the list
        selectedUser = null; // Clear selected user
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
  Future<void> removeMember(String userId) async {
    setState(() {
      isLoading = true;
    });

    try {
      final url = Uri.parse('${teamService.baseUrl}/team/removeMember');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "teamId": widget.teamId,
          "userId": userId,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          // Find the removed member if it exists
          final removedUser = teamMembers.firstWhere(
                (member) => member.id == userId,
            orElse: () => User(
              id: '',
              username: 'Unknown',
              email: '',
              role: 'player',
            ), // Provide a default User object instead of null
          );

          // Remove the member from teamMembers
          teamMembers.removeWhere((member) => member.id == userId);

          // Add back to available users if the user exists
          if (removedUser.id.isNotEmpty) {
            users.add(removedUser);
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Member removed successfully!")),
        );
      } else {
        throw Exception("Failed to remove member: ${response.body}");
      }
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

  void _confirmRemoveMember(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Member"),
        content: const Text("Are you sure you want to remove this member from the team?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close the dialog
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close the dialog
              await removeMember(userId); // Remove the member
            },
            child: const Text("Remove"),
          ),
        ],
      ),
    );
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
            const Text(
              "Team Members",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            teamMembers.isEmpty
                ? const Text("No members in the team yet")
                : ListView.builder(
              shrinkWrap: true,
              itemCount: teamMembers.length,
              itemBuilder: (context, index) {
                final member = teamMembers[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(member.username[0].toUpperCase()),
                  ),
                  title: Text(member.username),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmRemoveMember(member.id),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            DropdownButton<User>(
              value: selectedUser,
              hint: const Text("Select a user to add"),
              isExpanded: true,
              items: users.map((user) {
                return DropdownMenuItem<User>(
                  value: user,
                  child: Text(user.username),
                );
              }).toList(),
              onChanged: teamMembers.length >= 5
                  ? null // Disable selection if the limit is reached
                  : (User? value) {
                setState(() {
                  selectedUser = value;
                });
              },
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: teamMembers.length >= 5
                  ? null // Disable the button if the limit is reached
                  : addMember,
              child: const Text("Add Member"),
            ),

            const SizedBox(height: 8),
            if (teamMembers.length >= 5)
              const Text(
                "Team member limit reached (5 members).",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
      ),
    );
  }
}
