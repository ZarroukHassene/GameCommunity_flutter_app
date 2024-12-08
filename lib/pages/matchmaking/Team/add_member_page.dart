import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:gamefan_app/entities/user.dart';
import 'package:gamefan_app/pages/matchmaking/Team/TeamService.dart';
import 'package:gamefan_app/pages/user/user_service.dart';

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
    try {
      final fetchedUsers = await userService.getUsers(); // Get all users
      final fetchedTeam = await teamService.getTeamById(widget.teamId); // Get team details

      // Parse members as User objects
      List<User> membersDetails = [];
      for (var memberId in fetchedTeam.memberIds) {
        final member = await userService.getUserById(memberId); // Fetch each user's details
        membersDetails.add(member);
      }

      setState(() {
        teamMembers = membersDetails; // Existing team members
        users = fetchedUsers
            .where((user) => !fetchedTeam.memberIds.contains(user.id.toString()))
            .toList(); // Filter out existing team members
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
              onChanged: (User? value) {
                setState(() {
                  selectedUser = value;
                });
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addMember,
              child: const Text("Add Member"),
            ),
          ],
        ),
      ),
    );
  }
}
