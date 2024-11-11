import mongoose from "mongoose";
const { Schema, model } = mongoose;
const userSchema = new Schema({
    username: {
        type: String,
        required: true
    },
    email: {
        type: String,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    role: {
        type: String,
        required: true,
        enum: ["admin", "player"], // Enumerated roles
        default: "player" // Default role is "player"
    },
    banned: {
        type: Boolean,
        default: false // Default is not banned
    },
    blogs: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Blog' }] // Reference to Blog model
});

export default model("User", userSchema);
