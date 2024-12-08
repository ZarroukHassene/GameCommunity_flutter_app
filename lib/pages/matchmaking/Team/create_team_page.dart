import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gamefan_app/entities/Team.dart';
import 'package:gamefan_app/pages/matchmaking/Team/TeamService.dart';

class CreateTeamPage extends StatefulWidget {
  const CreateTeamPage({Key? key}) : super(key: key);

  @override
  State<CreateTeamPage> createState() => _CreateTeamPageState();
}

class _CreateTeamPageState extends State<CreateTeamPage> {
  final TeamService teamService = TeamService();
  final TextEditingController nameController = TextEditingController();
  File? selectedImage; // Holds the selected image file
  bool isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // Method to pick an image from the gallery
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  // Method to create a team
  void createTeam() async {
    final String name = nameController.text.trim();

    if (name.isEmpty || selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please provide all the required fields")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Upload the image and get the URL
      final imageUrl = await teamService.uploadImage(selectedImage!);

      // Create the team with the name and logo URL
      await teamService.createTeam(name, imageUrl);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Team created successfully!")),
      );

      // Clear inputs after successful creation
      nameController.clear();
      setState(() {
        selectedImage = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to create team: $e")),
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
        title: const Text("Create Team"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Team Name",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: "Enter team name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Team Logo",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: pickImage,
              child: Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: selectedImage == null
                    ? const Center(
                  child: Text("Tap to select an image"),
                )
                    : Image.file(
                  selectedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: createTeam,
              child: const Text("Create Team"),
            ),
          ],
        ),
      ),
    );
  }
}
