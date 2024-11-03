import  mongoose from 'mongoose';

const postSchema = new mongoose.Schema({
  content: {
    type: String,
    required: true
  },
  author: {
    type: String,
    ref: 'User',
    required: true
  },
  topic: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Topic',
    required: true
  },
  isDeleted: {
    type: Boolean,
    default: false
  }
}, { timestamps: true });

const Post = mongoose.model('Post', postSchema);

export default Post;