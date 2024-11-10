const express = require('express');
const router = express.Router();
const Feedback = require('../models/feedback');

// Submit feedback
router.post('/', async (req, res) => {
  const { sender, subject, messageBody } = req.body;

  try {
    const feedback = new Feedback({ sender, subject, messageBody });
    await feedback.save();

    res.status(201).json(feedback);
  } catch (error) {
    res.status(500).json({ error: 'Could not submit feedback.' });
  }
});

// Retrieve feedback (if needed for admin)
router.get('/', async (req, res) => {
  try {
    const feedback = await Feedback.find();
    res.status(200).json(feedback);
  } catch (error) {
    res.status(500).json({ error: 'Could not retrieve feedback.' });
  }
});

module.exports = router;
