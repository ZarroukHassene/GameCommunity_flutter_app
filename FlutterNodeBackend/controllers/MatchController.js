import Match from '../models/Match.js';
import Team from '../models/Team.js';

// Get all matches
const getAllMatches = async (req, res) => {
    try {
      const matches = await Match.find()
        .populate('teamA') // Populate full details for teamA
        .populate('teamB'); // Populate full details for teamB
  
      res.status(200).json(matches);
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: "Failed to fetch matches" });
    }
  };
  
  module.exports = { getAllMatches };
  

// Add a new match
export async function addMatch(req, res) {
  try {
    const { teamA, teamB, date } = req.body;

    // Ensure both teams exist
    const [teamAExists, teamBExists] = await Promise.all([
      Team.findById(teamA),
      Team.findById(teamB)
    ]);

    if (!teamAExists || !teamBExists) {
      return res.status(404).json({ error: 'One or both teams not found' });
    }

    // Create a new match
    const match = await Match.create({ teamA, teamB, date });
    res.status(201).json(match);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

// Get a match by ID
export function getMatchById(req, res) {
  Match.findById(req.params.id)
    .populate('teamA teamB') // Populate team details
    .then(match => {
      if (match) res.status(200).json(match);
      else res.status(404).json({ error: 'Match not found' });
    })
    .catch(err => res.status(500).json({ error: err.message }));
}

// Update a match
export async function updateMatch(req, res) {
  try {
    const { id } = req.params;
    const { teamA, teamB, date } = req.body;

    const updatedMatch = await Match.findByIdAndUpdate(
      id,
      { teamA, teamB, date },
      { new: true }
    );

    if (updatedMatch) res.status(200).json(updatedMatch);
    else res.status(404).json({ error: 'Match not found' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

// Delete a match
export function deleteMatch(req, res) {
  Match.findByIdAndDelete(req.params.id)
    .then(match => {
      if (match) res.status(200).json(match);
      else res.status(404).json({ error: 'Match not found' });
    })
    .catch(err => res.status(500).json({ error: err.message }));
}
