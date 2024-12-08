import Team from "../models/Team.js";
import User from "../models/user.js";

// Get all teams
export const getAllTeams = async (req, res) => {
  try {
    const teams = await Team.find().populate("members", "username email"); // Populate members with specific fields
    res.status(200).json(teams);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Get a single team by ID
export const getTeamById = async (req, res) => {
  try {
    const team = await Team.findById(req.params.id).populate("members", "username email");
    if (!team) {
      return res.status(404).json({ error: "Team not found" });
    }
    res.status(200).json(team);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Create a new team
export const createTeam = async (req, res) => {
  try {
    const { name, logo } = req.body;

    // Validate required fields
    if (!name || !logo) {
      return res.status(400).json({ error: "Name and logo are required" });
    }

    // Create and save the new team
    const newTeam = new Team({ name, logo });
    await newTeam.save();
    res.status(201).json(newTeam);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Update a team
export const updateTeam = async (req, res) => {
  try {
    const { name, logo } = req.body;

    const updatedTeam = await Team.findByIdAndUpdate(
      req.params.id,
      { name, logo },
      { new: true, runValidators: true } // Return the updated document
    );

    if (!updatedTeam) {
      return res.status(404).json({ error: "Team not found" });
    }

    res.status(200).json(updatedTeam);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Delete a team
export const deleteTeam = async (req, res) => {
  try {
    const deletedTeam = await Team.findByIdAndDelete(req.params.id);

    if (!deletedTeam) {
      return res.status(404).json({ error: "Team not found" });
    }

    res.status(200).json({ message: "Team deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Add a member to a team
export const addMemberToTeam = async (req, res) => {
  try {
    const { teamId, userId } = req.body;

    // Check if team exists
    const team = await Team.findById(teamId);
    if (!team) {
      return res.status(404).json({ error: "Team not found" });
    }

    // Check if user exists
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    // Add user to the team if not already a member
    if (!team.members.includes(userId)) {
      team.members.push(userId);
      await team.save();
    }

    res.status(200).json(team);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Remove a member from a team
export const removeMemberFromTeam = async (req, res) => {
  try {
    const { teamId, userId } = req.body;

    const team = await Team.findById(teamId);
    if (!team) {
      return res.status(404).json({ error: "Team not found" });
    }

    // Remove the user from the team members array
    team.members = team.members.filter((member) => member.toString() !== userId);
    await team.save();

    res.status(200).json(team);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};
