import  mongoose from 'mongoose';

const topicCategorySchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true
  },
  topics: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Topic'
  }],
  isDeleted: {
    type: Boolean,
    default: false
  }
}, { timestamps: true });

const TopicCategory = mongoose.model('TopicCategory', topicCategorySchema);

export default TopicCategory;