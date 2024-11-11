// routes/savedProductRoutes.js

const express = require('express');
const router = express.Router();
const savedProductController = require('../controllers/savedProductController');

// Add a saved product
router.post('/savedProducts', savedProductController.addSavedProduct);

// Get all saved products for a user
router.get('/savedProducts/:userId', savedProductController.getSavedProducts);

// Remove a saved product by its ID
router.delete('/savedProducts/:id', savedProductController.removeSavedProduct);

module.exports = router;
