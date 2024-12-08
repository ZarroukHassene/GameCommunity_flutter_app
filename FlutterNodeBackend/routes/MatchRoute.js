import express from 'express';
import { body } from 'express-validator';
const router = express.Router();
import { 
    getAllMatches, 
    addMatch, 
    getMatchById, 
    updateMatch, 
    deleteMatch 
} from '../controllers/MatchController.js'; // Import functions from MatchController

router.use(express.json()); // Parse requests with application/json content type

// Base routes for matches
router.route('/')
    .get(getAllMatches) // Get all matches
    .post(
        body('teamA').isMongoId(), // Validate teamA ID
        body('teamB').isMongoId(), // Validate teamB ID
        body('date').isISO8601().toDate(), // Validate date in ISO 8601 format
        addMatch // Add a new match
    );

// Routes for individual match operations by ID
router.route('/:id')
    .get(getMatchById) // Get a match by ID
    .put(
        body('teamA').optional().isMongoId(), // Validate teamA if provided
        body('teamB').optional().isMongoId(), // Validate teamB if provided
        body('date').optional().isISO8601().toDate(), // Validate date if provided
        updateMatch // Update a match
    )
    .delete(deleteMatch); // Delete a match

export default router;
