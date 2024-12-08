import express from 'express';
import mongoose from 'mongoose';
import morgan from 'morgan';
import cors from 'cors';
import { notfound } from './middlewares/notFound.js';
import uploadRoutes from "./routes/upload.js";
// Import routes
import postRouter from './routes/postrouter.js';
import TeamRouter from './routes/TeamRoute.js';
import MatchRouter from './routes/MatchRoute.js';
import topicRouter from './routes/topicrouter.js';
import topicCategoryRouter from './routes/topiccategoryrouter.js';
import userRouter from './routes/userrouter.js';
import productRouter from './routes/Products.js';

import BlogRoutes from './routes/BlogRoutes.js'
import cartRouter from './routes/CartRoutes.js';
const app = express();
const port = process.env.PORT || 9090;
const databaseName = 'GameFanAppDB';
const db_url = process.env.DB_URL || `mongodb://127.0.0.1:27017`;

mongoose.set('debug', true);
mongoose.Promise = global.Promise;

mongoose
  .connect(`${db_url}/${databaseName}`)
  .then(() => {
    console.log(`Connected to ${databaseName}`);
  })
  .catch((err) => {
    console.log(err);
  });


app.use(cors());
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(notfound);

// Define routes
app.use('/api/products', productRouter);
app.use('/posts', postRouter);
app.use('/topics', topicRouter);
app.use('/categories', topicCategoryRouter);
app.use('/user', userRouter);
app.use('/Team', TeamRouter);
app.use('/Match', MatchRouter);
// app.use('/api/card', savedProductRoutes);
app.use('/user/blog', BlogRoutes); 
app.use('/api/cart', cartRouter);

// Serve static files
app.use("/uploads", express.static("uploads")); // Serve the 'uploads' folder
app.use(uploadRoutes);


app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
