import  mongoose from 'mongoose';

const FeedbackSchema = new mongoose.Schema({
  sender: String,
  subject: String,
  messageBody: String,
  timestamp: {
    type: Date,
    default: Date.now
  }
});

const Feedback = mongoose.model('Feedback', FeedbackSchema);

export default Feedback; // Use ES module syntax for export
