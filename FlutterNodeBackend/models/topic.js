import  mongoose from 'mongoose';

const topicSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  author: {
    type: String,
    ref: 'User',
    required: true
  },
  category: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'TopicCategory',
    required: true
  },
  posts: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Post',
    required: false
  }],
  isClosed: {
    type: Boolean,
    default: false
  },
  isArchived: {
    type: Boolean,
    default: false
  }
}, { timestamps: true });

// Add a virtual field for post count
topicSchema.virtual('postCount').get(function() {
  return this.posts.length;
});

const Topic = mongoose.model('Topic', topicSchema);

export default Topic;