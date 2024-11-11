import TopicCategory from '../models/topiccategory.js';

const topicCategoryController = {
  // Get all categories
  getAllCategories: async (req, res) => {
    try {
      const categories = await TopicCategory.find({ isDeleted: false })
        .populate({
          path: 'topics',
          match: { isArchived: false },
          populate: { path: 'author', select: 'username' }
        });
      
      res.status(200).json(categories);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Create a new category
  createCategory: async (req, res) => {
    try {
      const { name } = req.body;
      const newCategory = await TopicCategory.create({
        name,
        topics: []
      });
      
      res.status(201).json(newCategory);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Update category name
  updateCategory: async (req, res) => {
    try {
      const { categoryId } = req.params;
      const { name } = req.body;

      const updatedCategory = await TopicCategory.findByIdAndUpdate(
        categoryId,
        { name },
        { new: true }
      );

      if (!updatedCategory) {
        return res.status(404).json({ message: 'Category not found' });
      }

      res.status(200).json(updatedCategory);
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  },

  // Delete category (soft delete)
  deleteCategory: async (req, res) => {
    try {
      const { categoryId } = req.params;
      const deletedCategory = await TopicCategory.findByIdAndUpdate(
        categoryId,
        { isDeleted: true },
        { new: true }
      );

      if (!deletedCategory) {
        return res.status(404).json({ message: 'Category not found' });
      }

      res.status(200).json({ message: 'Category deleted successfully' });
    } catch (error) {
      res.status(500).json({ message: error.message });
    }
  }
};

export default topicCategoryController;