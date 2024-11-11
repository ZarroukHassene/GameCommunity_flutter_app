import express from 'express';
import mongoose from 'mongoose';
import morgan from 'morgan';
import cors from 'cors';
import { notfound } from './middlewares/notFound.js'; // Import custom 404 middleware

// Import routes
import postRouter from './routes/postrouter.js';
import topicRouter from './routes/topicrouter.js';
import topicCategoryRouter from './routes/topiccategoryrouter.js';
<<<<<<< Updated upstream
import BlogRoutes from './routes/BlogRoutes.js'
=======
import userRouter from './routes/userrouter.js';
import productRouter from './routes/Products.js';

>>>>>>> Stashed changes

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
<<<<<<< Updated upstream
  .catch(err => {
    console.log("Error connecting to database:", err);
=======
  .catch((err) => {
    console.log(err);
>>>>>>> Stashed changes
  });

app.use(cors());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

<<<<<<< Updated upstream
// Use the routes
app.use('/user',userrouter)
app.use('/posts', postRouter);
app.use('/topics', topicRouter);
app.use('/categories', topicCategoryRouter);
app.use('/user/blog', BlogRoutes); 

// Handle 404 - Not Found
app.use(notfound);
=======
app.use(notfound);

// Define routes
app.use('/api/products', productRouter);
app.use('/posts', postRouter);
app.use('/topics', topicRouter);
app.use('/categories', topicCategoryRouter);
app.use('/user', userRouter);
app.use('/api/card', savedProductRoutes);
>>>>>>> Stashed changes

// Start the server
app.listen(port, () => {
<<<<<<< Updated upstream
    console.log(`Server running at http://localhost:${port}/`);
=======
  console.log(`Server running at http://localhost:${port}/`);
>>>>>>> Stashed changes
});
