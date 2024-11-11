import mongoose from 'mongoose';

const chatSchema = new mongoose.Schema({
  participants: [{ type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true }],
  messages: [
    {
      sender: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
      receiver: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
      message: { type: String, required: true },
      timestamp: { type: Date, default: Date.now }
    }
  ]
});

chatSchema.index({ participants: 1 }); // Ensure that the participants are indexed for faster lookup

export default mongoose.model('Chat', chatSchema);
