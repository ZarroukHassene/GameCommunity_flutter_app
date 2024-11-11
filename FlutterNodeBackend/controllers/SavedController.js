// controllers/savedProductController.js

const SavedProduct = require('../models/SavedProduct');

// Add a product to saved products
exports.addSavedProduct = async (req, res) => {
  try {
    const { userId, productId } = req.body;
    const savedProduct = new SavedProduct({ userId, productId });
    await savedProduct.save();
    res.status(201).json(savedProduct);
  } catch (error) {
    res.status(500).json({ message: 'Error adding saved product', error });
  }
};

// Get all saved products for a user
exports.getSavedProducts = async (req, res) => {
  try {
    const { userId } = req.params;
    const savedProducts = await SavedProduct.find({ userId }).populate('productId');
    res.status(200).json(savedProducts);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching saved products', error });
  }
};

// Remove a saved product
exports.removeSavedProduct = async (req, res) => {
  try {
    const { id } = req.params; // Saved product ID
    await SavedProduct.findByIdAndDelete(id);
    res.status(200).json({ message: 'Product removed from saved products' });
  } catch (error) {
    res.status(500).json({ message: 'Error removing saved product', error });
  }
};
