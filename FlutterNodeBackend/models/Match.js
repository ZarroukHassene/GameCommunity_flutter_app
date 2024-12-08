import mongoose from "mongoose";

const { Schema, model } = mongoose;

const matchSchema = new Schema({
    teamA: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Team', // References the Team model
        required: true
    },
    teamB: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Team', // References the Team model
        required: true
    },
    date: { 
        type: Date, 
        required: true // Ensures a match date is always provided
    }
}, { timestamps: true }); // Automatically add createdAt and updatedAt fields

export default model("Match", matchSchema);
