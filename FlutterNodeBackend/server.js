import express from 'express';
import mongoose from 'mongoose';
import morgan from 'morgan';
import cors from 'cors';
import { notfound } from './middlewares/notFound.js';
import dotenv from 'dotenv';
import http from 'http';
import { Server } from 'socket.io';
// Import routes
import postRouter from './routes/postrouter.js';
import topicRouter from './routes/topicrouter.js';
import topicCategoryRouter from './routes/topiccategoryrouter.js';
import userRouter from './routes/userrouter.js';
import productRouter from './routes/Products.js';

import BlogRoutes from './routes/BlogRoutes.js'
import cartRouter from './routes/CartRoutes.js';
import chatRoutes from './routes/chatRoutes.js';          // Import chat routes
import feedbackRoutes from './routes/feedbackRoutes.js';  // Import feedback routes
import Chat from './models/chat.js';
dotenv.config();
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

  const server = http.createServer(app);
  const io = new Server(server, {
    cors: {
      origin: 'http://localhost:50302',
      methods: ['GET', 'POST', 'PUT', 'DELETE']
    }
  });
  
  // Middleware
app.use(cors({ origin: 'http://localhost:50302', methods: ['GET', 'POST', 'PUT', 'DELETE'] }));

app.use(morgan('dev'));
  
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
// app.use('/api/card', savedProductRoutes);
app.use('/user/blog', BlogRoutes); 
app.use('/api/cart', cartRouter);
app.use('/chat', chatRoutes);         // Use chat routes
app.use('/feedback', feedbackRoutes);  // Use feedback routes

// Handle undefined routes
app.use(notfound);

// Socket.IO events
io.on('connection', (socket) => {
  console.log('A user connected');

  socket.on('send_message', async (data) => {
    const { sender, receiver, content } = data;

    try {
      let chat = await Chat.findOne({ participants: { $all: [sender, receiver] } });

      if (chat) {
        chat.messages.push({ content, sender });
        await chat.save();
        console.log('Message saved to existing chat');
      } else {
        chat = new Chat({
          participants: [sender, receiver],
          messages: [{ content, sender }]
        });
        await chat.save();
        console.log('New chat created and message saved');
      }

      io.emit('receive_message', data);
    } catch (err) {
      console.error('Error handling message:', err);
    }
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}/`);
});
