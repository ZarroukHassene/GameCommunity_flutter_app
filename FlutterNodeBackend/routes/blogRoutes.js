import express from "express";
import { 
    createBlog, 
    getUserBlogs, 
    updateBlog, 
    deleteBlog, 
    addComment, 
    deleteComment ,
    getAllBlogs
} from "../controllers/UserBlogController.js"; // Make sure to include the correct .js extension

const router = express.Router();

// Routes for blog management
router.post("/", createBlog); // Create a new blog
router.get("/", getUserBlogs); // Get all blogs of the user
router.put("/", updateBlog); // Update a specific blog
router.delete("/:blogId", deleteBlog); // Delete a specific blog

// Routes for comment management
router.post("/comment", addComment); // Add a comment to a blog
router.delete("/comment/:commentId", deleteComment); // Delete a specific comment
router.get('/blogs', getAllBlogs);
export default router;
