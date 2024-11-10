const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const connectDB = require('./config/db');
const blogRoutes = require('./routes/blogRoutes');
const { notFoundError, errorHandler } = require('./middlewares/error-handler');
require('dotenv').config();

const app = express();

// Connect to MongoDB
connectDB();

// Middleware
app.use(cors());
app.use(bodyParser.json());


// Routes
app.use('/api', blogRoutes);

// Use the middleware for unknown routes
app.use(notFoundError);

// Use the error handler middleware
app.use(errorHandler);

// Start the server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
