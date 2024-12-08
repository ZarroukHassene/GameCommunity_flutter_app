import express from "express";
import {
  getAllTeams,
  getTeamById,
  createTeam,
  updateTeam,
  deleteTeam,
  addMemberToTeam,
  removeMemberFromTeam,
} from "../controllers/TeamController.js";

const router = express.Router();

router.get("/", getAllTeams);
router.get("/:id", getTeamById);
router.post("/", createTeam);
router.put("/:id", updateTeam);
router.delete("/:id", deleteTeam);
router.post("/addMember", addMemberToTeam);
router.post("/removeMember", removeMemberFromTeam);

export default router;
