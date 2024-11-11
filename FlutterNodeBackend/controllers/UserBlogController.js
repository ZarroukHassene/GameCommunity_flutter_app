import {Blog , Comment} from "../models/Blog.js";   // Import Blog model
import User from "../models/user.js";



// Create a blog and add it to the user's blog list
export const createBlog = async (req, res) => {
    try {
        const { title, description , userId } = req.body;
      // Assuming userId comes from the request context (e.g., from session or middleware)

        const newBlog = new Blog({
            title,
            description,
            user: userId,
        });

        // Save the new blog to the database
        await newBlog.save();

        // Add the blog to the user's blog list
        const user = await User.findById(userId);
        user.blogs.push(newBlog._id);
        await user.save();

        res.status(201).json(newBlog);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Error creating blog" });
    }
};

export const getUserBlogs = async (req, res) => {
    try {
      const blog = await Blog.findById(req.params.blogId)
        .populate({
          path: 'comments',
          populate: { path: 'user', select: 'username' }, // Populate user data within each comment
        })
        .populate('user', 'username'); // Populate blog owner data
  
      if (!blog) {
        return res.status(404).json({ message: 'Blog not found' });
      }
  
      res.status(200).json(blog);
    } catch (error) {
      res.status(500).json({ message: 'Error fetching blog details', error: error.message });
    }
  };
  
// Assuming you have a `Comment` model that references a `User` model

export const getCommentById = async (req, res) => {
    try {
      const { commentId } = req.params;
  
      // Find the comment and include user details
      const comment = await Comment.findById(commentId).populate('user', 'username');
  
      if (!comment) {
        return res.status(404).json({ message: 'Comment not found' });
      }
  
      res.status(200).json(comment); // Ensure it returns `text`, `_id`, and `user`
    } catch (error) {
      res.status(500).json({ message: 'Error fetching comment details', error: error.message });
    }
  };
  

// Update a blog (only allowed for the owner of the blog)
export const updateBlog = async (req, res) => {
    try {
        const { blogId, title, description } = req.body;
        const userId = req.userId;

        const blog = await Blog.findById(blogId);
        if (!blog) {
            return res.status(404).json({ message: "Blog not found" });
        }

        if (blog.user.toString() !== userId) {
            return res.status(403).json({ message: "You are not the owner of this blog" });
        }

        blog.title = title || blog.title;
        blog.description = description || blog.description;

        await blog.save();
        res.status(200).json(blog);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Error updating blog" });
    }
};

// Delete a blog (only allowed for the owner of the blog)
export const deleteBlog = async (req, res) => {
    try {
        const { blogId } = req.params;
        const userId = req.userId;

        const blog = await Blog.findById(blogId);
        if (!blog) {
            return res.status(404).json({ message: "Blog not found" });
        }

        if (blog.user.toString() !== userId) {
            return res.status(403).json({ message: "You are not the owner of this blog" });
        }

        // Remove the blog from the user's blog list
        const user = await User.findById(userId);
        user.blogs.pull(blogId);
        await user.save();

        // Delete the blog
        await blog.remove();

        res.status(200).json({ message: "Blog deleted successfully" });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Error deleting blog" });
    }
};

// Add a comment to a blog based on the user
export const addComment = async (req, res) => {
    try {
        const { blogId, text, userId } = req.body;
        //const userId = req.userId;

        const blog = await Blog.findById(blogId);
        if (!blog) {
            return res.status(404).json({ message: "Blog not found" });
        }

        const newComment = new Comment({
            text,
            user: userId,
            blog: blogId,
        });

        // Save the comment and add it to the blog
        await newComment.save();
        blog.comments.push(newComment._id);
        await blog.save();

        res.status(201).json(newComment);
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Error adding comment" });
    }
};

// Delete a comment (only allowed for the owner of the comment)
export const deleteComment = async (req, res) => {
    try {
        const { commentId } = req.params;
        const userId = req.userId;

        const comment = await Comment.findById(commentId);
        if (!comment) {
            return res.status(404).json({ message: "Comment not found" });
        }

        if (comment.user.toString() !== userId) {
            return res.status(403).json({ message: "You are not the owner of this comment" });
        }

        // Remove the comment from the blog
        const blog = await Blog.findById(comment.blog);
        blog.comments.pull(commentId);
        await blog.save();

        // Delete the comment
        await comment.remove();

        res.status(200).json({ message: "Comment deleted successfully" });
    } catch (err) {
        console.error(err);
        res.status(500).json({ message: "Error deleting comment" });
    }
    // Controller function to get all blogs


  
};

export function getAllBlogs(req,res){
    Blog
    .find({})
    .then(docs=>{
        res.status(200).json(docs);
    })
    .catch(err=>{
        res.status(500).json({error:err});
    });
};

// Controller function to get a single blog by ID
export const getSingleBlog = async (req, res) => {
    try {
      const blog = await Blog.findById(req.params.blogId).populate('user', 'username');
      if (!blog) {
        return res.status(404).json({ message: 'Blog not found' });
      }
      res.status(200).json(blog);
    } catch (error) {
      res.status(500).json({ message: 'Error fetching blog detailsssssssss', error: error.message });
    }
  };
  