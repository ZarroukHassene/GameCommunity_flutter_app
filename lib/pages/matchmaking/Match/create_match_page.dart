import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:gamefan_app/pages/matchmaking/Match/match_service.dart';
import 'package:flutter/material.dart';
import 'package:gamefan_app/pages/matchmaking/Team/TeamService.dart';
import 'package:gamefan_app/entities/Team.dart';
class CreateMatchPage extends StatefulWidget {
  const CreateMatchPage({Key? key}) : super(key: key);

  @override
  State<CreateMatchPage> createState() => _CreateMatchPageState();
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  final MatchService matchService = MatchService();
  final TeamService teamService = TeamService();

  List<Team> teams = [];
  Team? selectedTeamA;
  Team? selectedTeamB;
  DateTime? selectedDateTime;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeams();
  }

  // Fetch all teams for the dropdown
  void fetchTeams() async {
    try {
      final fetchedTeams = await teamService.getTeams();
      setState(() {
        teams = fetchedTeams;
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

  // Pick date and time
  Future<void> pickDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  // Create a new match
  void createMatch() async {
    if (selectedTeamA == null || selectedTeamB == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both teams")),
      );
      return;
    }

    if (selectedTeamA == selectedTeamB) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Team A and Team B must be different")),
      );
      return;
    }

    if (selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a date and time")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await matchService.createMatch(
        selectedTeamA!.id,
        selectedTeamB!.id,
        selectedDateTime!.toIso8601String(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Match created successfully!")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create match: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Get the list of teams excluding the one already selected in Team B
  List<Team> getFilteredTeamsForA() {
    return teams.where((team) => team != selectedTeamB).toList();
  }

  // Get the list of teams excluding the one already selected in Team A
  List<Team> getFilteredTeamsForB() {
    return teams.where((team) => team != selectedTeamA).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Match"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Team A"),
            const SizedBox(height: 8),
            DropdownButton<Team>(
              value: selectedTeamA,
              hint: const Text("Select Team A"),
              isExpanded: true,
              items: getFilteredTeamsForA().map((team) {
                return DropdownMenuItem<Team>(
                  value: team,
                  child: Text(team.name.toString()),
                );
              }).toList(),
              onChanged: (Team? newValue) {
                setState(() {
                  selectedTeamA = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text("Team B"),
            const SizedBox(height: 8),
            DropdownButton<Team>(
              value: selectedTeamB,
              hint: const Text("Select Team B"),
              isExpanded: true,
              items: getFilteredTeamsForB().map((team) {
                return DropdownMenuItem<Team>(
                  value: team,
                  child: Text(team.name.toString()),
                );
              }).toList(),
              onChanged: (Team? newValue) {
                setState(() {
                  selectedTeamB = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text("Date and Time"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: pickDateTime,
              child: AbsorbPointer(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: selectedDateTime == null
                        ? "Select date and time"
                        : DateFormat("yyyy-MM-dd HH:mm")
                        .format(selectedDateTime!),
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: createMatch,
              child: const Text("Create Match"),
            ),
          ],
        ),
      ),
    );
  }
}
