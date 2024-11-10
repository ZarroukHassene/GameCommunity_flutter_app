const express = require('express');
const router = express.Router();
const Chat = require('../models/chat');  // Assuming your Chat model is correctly defined

// POST route to add a new message (without needing `chatId`)
router.post('/messages', async (req, res) => {
  const { sender, receiver, content } = req.body;

  try {
    // Find an existing chat between the sender and receiver
    let chat = await Chat.findOne({ participants: { $all: [sender, receiver] } });
    
    // If no chat exists, create a new one
    if (!chat) {
      chat = new Chat({ participants: [sender, receiver], messages: [] });
    }

    // Add the new message to the chat
    const newMessage = { content, sender, timestamp: new Date() };
    chat.messages.push(newMessage);

    // Save the chat with the new message
    await chat.save();

    res.status(200).json({ message: 'Message added successfully', newMessage });
  } catch (error) {
    console.error('Error saving message:', error);
    res.status(500).json({ error: 'Could not add message.' });
  }
});
// Get messages between two participants
router.get('/conversation', async (req, res) => {
  const { sender, receiver } = req.query;

  if (!sender || !receiver) {
    return res.status(400).json({ error: 'Sender and receiver are required' });
  }

  try {
    // Find the chat document where both sender and receiver are participants
    const chat = await Chat.findOne({
      participants: { $all: [sender, receiver] }, // Ensure both sender and receiver are in the participants array
    });

    if (!chat) {
      return res.status(404).json({ error: 'No conversation found between these participants' });
    }

    // Return the messages sorted by timestamp
    const messages = chat.messages.sort((a, b) => a.timestamp - b.timestamp);

    res.status(200).json(messages);
  } catch (error) {
    res.status(500).json({ error: 'Could not retrieve messages' });
  }
});
module.exports = router;
