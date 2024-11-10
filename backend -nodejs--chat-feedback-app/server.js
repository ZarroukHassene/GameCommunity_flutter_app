const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const cors = require('cors');
const http = require('http');
const socketIo = require('socket.io');
dotenv.config();

// Import the Chat model
const Chat = require('./models/chat');

const app = express();
const PORT = process.env.PORT || 4000;

// Create HTTP server using Express app
const server = http.createServer(app);

// Initialize Socket.IO with the HTTP server
const io = socketIo(server);

// Middleware
app.use(cors({ origin: 'http://localhost:54020', methods: ['GET', 'POST', 'PUT', 'DELETE'] }));
app.use(express.json()); // Built-in body parser

// MongoDB connection
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('MongoDB connected'))
  .catch((error) => console.error('MongoDB connection error:', error));

// Handle undefined routes
app.use((req, res) => {
  res.status(404).json({ error: 'Route not found' });
});

// Handle Socket.IO events
io.on('connection', (socket) => {
  console.log('A user connected');

  // Listen for 'send_message' events from clients
  socket.on('send_message', async (data) => {
    const { sender, receiver, content } = data;

    try {
      // Check if a chat already exists between sender and receiver
      const chat = await Chat.findOne({ participants: { $all: [sender, receiver] } });

      if (chat) {
        // If chat exists, add the new message to the chat
        chat.messages.push({ content, sender });
        await chat.save();
        console.log('Message saved to existing chat');
        io.emit('receive_message', data);  // Broadcast the message to all clients
      } else {
        // If no chat exists, create a new chat with the sender and receiver as participants
        const newChat = new Chat({
          participants: [sender, receiver],
          messages: [{ content, sender }],
        });

        await newChat.save();
        console.log('New chat created and message saved');
        io.emit('receive_message', data);  // Broadcast the message to all clients
      }
    } catch (err) {
      console.error('Error handling message:', err);
    }
  });

  // Handle client disconnecting
  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

// Start server
server.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
