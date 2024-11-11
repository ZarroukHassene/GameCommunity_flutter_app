// models/SavedProduct.js

const mongoose = require('mongoose');

const savedProductSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  productId: { type: mongoose.Schema.Types.ObjectId, ref: 'Product', required: true },
  savedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('SavedProduct', savedProductSchema);
