const mongoose = require('mongoose');
const { Schema } = mongoose;  // Ensure this line is present

const commentSchema = new Schema({
    text: { type: String, required: true },
    createdAt: { type: Date, default: Date.now }
});

const blogSchema = new Schema({
    title: { type: String, required: true },
    description: { type: String, required: true },
    comments: [commentSchema],  // Array of comments
    user: { type: Schema.Types.ObjectId, ref: 'User', required: true }  // Reference to the User who created the blog
}, { timestamps: true });

module.exports = mongoose.model('Blog', blogSchema);
