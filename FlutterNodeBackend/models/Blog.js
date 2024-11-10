import mongoose from "mongoose";
const { Schema } = mongoose;

// Define the comment schema
const commentSchema = new Schema({
    text: { type: String, required: true },
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true },
    createdAt: { type: Date, default: Date.now }
});

// Define the blog schema
const blogSchema = new Schema({
    title: { type: String, required: true },
    description: { type: String, required: true },
    comments: [{ type: Schema.Types.ObjectId, ref: 'Comment' }],  // Reference to Comment model
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true }  // Reference to the User who created the blog
}, { timestamps: true });

// Create models for Comment and Blog
const Comment = mongoose.model('Comment', commentSchema);
const Blog = mongoose.model('Blog', blogSchema);

export { Comment, Blog };
