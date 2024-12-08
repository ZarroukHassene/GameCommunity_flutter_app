import mongoose from "mongoose";

const { Schema, model } = mongoose;

const teamSchema = new Schema({
    name: {
        type: String,
        required: true,
        unique: true, // Ensures team names are unique
        trim: true // Automatically trims whitespace
    },
    members: [{ 
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'User' // References the User model
    }],
    logo: { 
        type: String, 
        required: true 
    }   
}, { timestamps: true }); // Automatically add createdAt and updatedAt fields

export default model("Team", teamSchema);
