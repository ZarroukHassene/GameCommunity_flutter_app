import Topic from '../models/topic.js';
import Post from '../models/post.js';
import TopicCategory from '../models/topiccategory.js';
import User from '../models/user.js';

const topicController = {
  // Get all topics for a category
  getCategoryTopics: async (req, res) => {
    try {
      const { categoryId } = req.params;
      const topics = await Topic.find({ 
        category: categoryId,
        isArchived: false 
      })
      .populate('author', 'username')
      .sort({ createdAt: 'desc' });

      res.status(200).json(topics);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  createTopic: async (req, res) => {
    try {
      const { categoryId } = req.params;
      const { title, authorId, initialPost } = req.body;

      // Step 1: Create the topic without posts initially
      const newTopic = await Topic.create({
        title,
        author: authorId,
        category: categoryId,
        posts: [] // Initialize posts as an empty array
      });

      // Step 2: Create the initial post
      const firstPost = await Post.create({
        content: initialPost,
        author: authorId,
        topic: newTopic._id
      });

      // Step 3: Update the topic's posts array with the first post
      newTopic.posts.push(firstPost._id);
      await newTopic.save();

      // Step 4: Add the new topic to the category's topics array
      await TopicCategory.findByIdAndUpdate(
        categoryId,
        { $push: { topics: newTopic._id } },
        { new: true }
      );

      // Populate the author information in the topic for response
      await newTopic.populate('author', 'username');

      // Send the created topic back in the response
      res.status(201).json(newTopic);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },


  // Update topic status (close/archive)
  updateTopicStatus: async (req, res) => {
    try {
      const { topicId } = req.params;
      const { isClosed, isArchived } = req.body;

      const updatedTopic = await Topic.findByIdAndUpdate(
        topicId,
        { 
          ...(isClosed !== undefined && { isClosed }),
          ...(isArchived !== undefined && { isArchived })
        },
        { new: true }
      );

      if (!updatedTopic) {
        return res.status(404).json({ message: 'Topic not found' });
      }

      res.status(200).json(updatedTopic);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },
};

export default topicController;