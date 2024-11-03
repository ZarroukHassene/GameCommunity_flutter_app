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
  }
};

export default postController;
