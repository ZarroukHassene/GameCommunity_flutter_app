import express from 'express';
import Chat from '../models/chat.js';
import mongoose from 'mongoose';

const router = express.Router();

// Route to get all messages between two users
router.get('/conversations/:userId1/:userId2', async (req, res) => {
  const { userId1, userId2 } = req.params;

  try {
    // Find the conversation between the two users
    const conversation = await Chat.findOne({
      participants: { $all: [userId1, userId2] }
    });

    if (conversation) {
      res.status(200).json(conversation.messages); // Return messages if conversation exists
    } else {
      res.status(200).json([]); // Return an empty array if no conversation exists
    }
  } catch (error) {
    res.status(500).json({ error: 'Failed to retrieve messages' });
  }
});

// Route to send a new message
router.post('/send', async (req, res) => {
  const { sender, receiver, message } = req.body;

  if (!sender || !receiver || !message) {
    return res.status(400).json({ error: 'Sender, receiver, and message are required.' });
  }

  if (!mongoose.Types.ObjectId.isValid(sender) || !mongoose.Types.ObjectId.isValid(receiver)) {
    return res.status(400).json({ error: 'Invalid sender or receiver ID' });
  }

  try {
    // Check if a conversation between the two users already exists
    let conversation = await Chat.findOne({
      participants: { $all: [sender, receiver] }
    });

    // If conversation doesn't exist, create a new one
    if (!conversation) {
      conversation = new Chat({
        participants: [sender, receiver],
        messages: []
      });
    }

    // Add the new message to the conversation
    const newMessage = {
      sender,
      receiver,
      message,
      timestamp: new Date()
    };

    conversation.messages.push(newMessage);
    await conversation.save();

    res.status(200).json({
      message: 'Message sent successfully',
      newMessage
    });
  } catch (error) {
    console.error('Error saving message:', error.message); // Log the specific error
    console.error('Stack Trace:', error.stack); // Log the stack trace for debugging
    res.status(500).json({ error: 'Failed to send message', details: error.message });
  }
});

export default router;
