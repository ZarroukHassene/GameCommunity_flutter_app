const mongoose = require('mongoose');

const FeedbackSchema = new mongoose.Schema({
  sender: String,
  subject: String,
  messageBody: String,
  timestamp: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Feedback', FeedbackSchema);
