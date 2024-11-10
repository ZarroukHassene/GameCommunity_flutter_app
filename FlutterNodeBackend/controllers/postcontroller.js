import Post from '../models/post.js';
import Topic from '../models/topic.js';

const postController = {
  // Get all posts for a specific topic
  getTopicPosts: async (req, res) => {
    try {
      const { topicId } = req.params;
      const posts = await Post.find({
        topic: topicId,
        isDeleted: false
      })
        .populate('author', 'username')
        .sort({ createdAt: 'asc' });

      res.status(200).json(posts);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }, // Create a new post in a topic
  createPost: async (req, res) => {
    try {
      const { topicId } = req.params;
      const { content, authorId } = req.body;

      // Create the post
      const newPost = await Post.create({
        content,
        author: authorId,
        topic: topicId
      });

      // Add post to topic's posts array
      await Topic.findByIdAndUpdate(
        topicId,
        { $push: { posts: newPost._id } },
        { new: true }
      );

      await newPost.populate('author', 'username');

      res.status(201).json(newPost);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Delete a post (soft delete)
  deletePost: async (req, res) => {
    try {
      const { postId } = req.params;
      const deletedPost = await Post.findByIdAndUpdate(
        postId,
        { isDeleted: true },
        { new: true }
      );

      if (!deletedPost) {
        return res.status(404).json({ message: 'Post not found' });
      }

      res.status(200).json({ message: 'Post deleted successfully' });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },


  updatePostLikes: async (req, res) => {
    const { userId, postId } = req.body;
  
    try {
      const post = await Post.findById(postId);
      if (!post) {
        return res.status(404).json({ message: "Post not found" });
      }
  
      const alreadyLiked = post.userLikes.includes(userId);
  
      if (alreadyLiked) {
        // Unlike: Remove the user's ID from userLikes
        post.userLikes = post.userLikes.filter(id => id.toString() !== userId);
      } else {
        // Like: Add the user's ID to userLikes
        post.userLikes.push(userId);
      }
  
      await post.save();
      return res.status(200).json({ message: alreadyLiked ? "Post unliked successfully" : "Post liked successfully", likes: post.userLikes.length });
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Server error" });
    }
  }
  
};
export default postController;
