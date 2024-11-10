const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  content: String,
  sender: String,
  timestamp: {
    type: Date,
    default: Date.now,
  },
});

const chatSchema = new mongoose.Schema({
  participants: [String], // Array of participant IDs (sender and receiver)
  messages: [messageSchema], // Array of message subdocuments
});

const Chat = mongoose.model('Chat', chatSchema);

module.exports = Chat;
