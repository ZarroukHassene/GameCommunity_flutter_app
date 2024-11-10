const express = require('express');
const multer = require('multer'); // Assuming multer is being used for file upload
const { body } = require('express-validator'); // Assuming express-validator is being used

const blogController = require('../controllers/blogController');
const userController = require('../controllers/userController'); // Import user controller

const router = express.Router();

// User routes
router.route('/users')
  .get(userController.getAllUsers)  // Fetch all users
  .post(
    multer, // Use multer for file uploads
    body('username').isLength({ min: 5 }), // Username must have at least 5 characters
    body('password').isLength({ min: 4 }),  // Password must have at least 4 characters
    body('email').isEmail(),
    userController.addUser  // Add a new user
  );

router.route('/users/:username')
  .get(userController.findByUserName)  // Get user by username
  .delete(userController.deleteOnce);  // Delete user by username

router.route('/users/login')
  .post(userController.authenticateUser);  // User login

router.route('/users/changeRole')
  .post(userController.toggleUserRole);  // Toggle user role between admin and player

router.route('/users/banUser')
  .post(userController.toggleUserBan);  // Toggle user ban status

// Blog routes
router.route('/blogs')
  .post(
    // Assuming a middleware for checking authentication
    userController.authenticateUser, // Middleware to authenticate user
    blogController.createBlog)  // Create a new blog
  .get(blogController.getBlogs);    // Get all blogs

router.route('/blogs/:id')
  .get(blogController.getBlogById)  // Get a blog by ID
  .put(
    userController.authenticateUser, // Middleware to authenticate user
    blogController.updateBlog)   // Update a blog by ID
  .delete(
    userController.authenticateUser, // Middleware to authenticate user
    blogController.deleteBlog);  // Delete a blog by ID

// Comment routes
router.route('/blogs/:id/comments')
  .post(
    userController.authenticateUser, // Middleware to authenticate user
    blogController.addComment)  // Add a comment to a blog
  .get(blogController.getComments); // Get all comments for a blog

router.route('/blogs/:blogId/comments/:commentId')
  .put(
    userController.authenticateUser, // Middleware to authenticate user
    blogController.updateComment)  // Update a specific comment
  .delete(
    userController.authenticateUser, // Middleware to authenticate user
    blogController.deleteComment); // Delete a specific comment

module.exports = router;
