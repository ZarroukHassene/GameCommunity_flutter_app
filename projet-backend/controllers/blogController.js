const Blog = require('../models/blog');
const User = require('../models/user'); // Import user model to associate blog with user
const path = require('path');

// Set the default image path
const notFoundImage = path.join('uploads', 'notfound.png');

// Create a new blog
exports.createBlog = async (req, res) => {
    try {
        const { title, description } = req.body;
        const userId = req.user._id; // Assume the user is authenticated, and their ID is in req.user._id

        // Create a new blog associated with the user
        const newBlog = new Blog({
            title,
            description,
            user: userId, // Associate blog with the user who created it
        });

        await newBlog.save();
        res.status(201).json(newBlog);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Get all blog posts
exports.getBlogs = async (req, res) => {
    try {
        const blogs = await Blog.find();
        res.status(200).json(blogs);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Get a single blog post
exports.getBlogById = async (req, res) => {
    try {
        const blog = await Blog.findById(req.params.id);
        if (!blog) return res.status(404).json({ message: 'Blog not found' });
        res.status(200).json(blog);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Update a blog post
exports.updateBlog = async (req, res) => {
    try {
        const { title, description } = req.body;
        const blog = await Blog.findById(req.params.id);

        if (!blog) return res.status(404).json({ message: 'Blog not found' });

        // Check if the logged-in user is the one who created the blog
        if (blog.user.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'You can only update your own blog' });
        }

        blog.title = title || blog.title;
        blog.description = description || blog.description;

        await blog.save();
        res.status(200).json(blog);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Delete a blog post
exports.deleteBlog = async (req, res) => {
    try {
        const blog = await Blog.findById(req.params.id);

        if (!blog) return res.status(404).json({ message: 'Blog not found' });

        // Check if the logged-in user is the one who created the blog
        if (blog.user.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'You can only delete your own blog' });
        }

        await blog.remove();
        res.status(200).json({ message: 'Blog deleted successfully' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Add a comment to a blog
exports.addComment = async (req, res) => {
    try {
        const { id } = req.params; // Blog ID
        const { text } = req.body;
        const userId = req.user._id; // Get the user who is commenting

        const blog = await Blog.findById(id);
        if (!blog) return res.status(404).json({ message: 'Blog not found' });

        // Create a new comment with the userId
        blog.comments.push({ text, user: userId });
        await blog.save();
        res.status(201).json(blog); // Send back the updated blog
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Get all comments for a blog
exports.getComments = async (req, res) => {
    try {
        const { blogId } = req.params;
        const blog = await Blog.findById(blogId);
        if (!blog) return res.status(404).json({ message: 'Blog not found' });

        res.json(blog.comments);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Update a comment
exports.updateComment = async (req, res) => {
    try {
        const { text } = req.body; // Assuming we update the comment text
        const { blogId, commentId } = req.params;
        const blog = await Blog.findById(blogId);

        if (!blog) {
            return res.status(404).json({ message: 'Blog not found' });
        }

        const comment = blog.comments.id(commentId);
        if (!comment) {
            return res.status(404).json({ message: 'Comment not found' });
        }

        // Check if the logged-in user is the one who created the comment
        if (comment.user.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'You can only update your own comments' });
        }

        comment.text = text || comment.text;
        await blog.save();

        res.status(200).json(blog);
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};

// Delete a comment
exports.deleteComment = async (req, res) => {
    try {
        const { blogId, commentId } = req.params;
        const blog = await Blog.findById(blogId);

        if (!blog) {
            return res.status(404).json({ message: 'Blog not found' });
        }

        const comment = blog.comments.id(commentId);
        if (!comment) {
            return res.status(404).json({ message: 'Comment not found' });
        }

        // Check if the logged-in user is the one who created the comment
        if (comment.user.toString() !== req.user._id.toString()) {
            return res.status(403).json({ message: 'You can only delete your own comments' });
        }

        comment.remove();
        await blog.save();

        res.status(200).json({ message: 'Comment deleted successfully' });
    } catch (err) {
        res.status(500).json({ message: err.message });
    }
};
