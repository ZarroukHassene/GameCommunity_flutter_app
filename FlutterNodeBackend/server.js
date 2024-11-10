import express from 'express';
import mongoose from 'mongoose';
import morgan from 'morgan';
import cors from 'cors';
import { notfound } from './middlewares/notFound.js'; // Import custom 404 middleware

// Import routes
import postRouter from './routes/postrouter.js';
import topicRouter from './routes/topicrouter.js';
import topicCategoryRouter from './routes/topiccategoryrouter.js';
import BlogRoutes from './routes/BlogRoutes.js'

import userrouter from './routes/userrouter.js'
const app = express();
const port = process.env.PORT || 9090;
const databaseName = 'GameFanAppDB';
const db_url = process.env.DB_URL || `mongodb://127.0.0.1:27017`;

mongoose.set('debug', true);
mongoose.Promise = global.Promise;

// MongoDB connection
mongoose
  .connect(`${db_url}/${databaseName}`)
  .then(() => {
    console.log(`Connected to ${databaseName}`);
  })
  .catch(err => {
    console.log("Error connecting to database:", err);
  });

app.use(cors());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Use the routes
app.use('/user',userrouter)
app.use('/posts', postRouter);
app.use('/topics', topicRouter);
app.use('/categories', topicCategoryRouter);
app.use('/user/blog', BlogRoutes); 

// Handle 404 - Not Found
app.use(notfound);

// Start the server
app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}/`);
});
