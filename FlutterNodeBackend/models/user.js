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
    }
});

export default model("User", userSchema);
