const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const cors = require('cors'); // Import CORS for cross-origin requests

dotenv.config();

const chatRoutes = require('./routes/chatRoutes');
const feedbackRoutes = require('./routes/feedbackRoutes');

const app = express();

// Middleware
app.use(cors({
  origin: 'http://localhost:54020', // Update this to match the actual port for your Flutter app
  methods: ['GET', 'POST', 'PUT', 'DELETE']
}));
app.use(express.json()); // Built-in body parser

// Routes
app.use('/api/chats', chatRoutes);
app.use('/api/feedback', feedbackRoutes);

// MongoDB connection
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log('MongoDB connected'))
  .catch((error) => console.error('MongoDB connection error:', error));

// Handle undefined routes
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Set the port
const PORT = process.env.PORT || 4000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

module.exports = app;
