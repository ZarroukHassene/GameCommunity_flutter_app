const bcrypt = require('bcrypt');
const { validationResult } = require('express-validator'); // Correct import for express-validator
const User = require('../models/user'); // Assuming the User model is in models/user

const saltRounds = 10;

// Get all users
function getAllUsers(req, res) {
  User.find({})
    .then(docs => {
      res.status(200).json(docs);
    })
    .catch(err => {
      res.status(500).json({ error: err });
    });
}

// Add a new user
async function addUser(req, res) {
  if (!validationResult(req).isEmpty()) {
    return res.status(400).json({ error: validationResult(req).array() });
  }

  try {
    const existingAccount = await User.findOne({ $or: [{ username: req.body.username }] });
    if (existingAccount) {
      return res.status(409).json({ error: "Account with the same username or email already exists" });
    }

    const salt = await bcrypt.genSalt(saltRounds);
    const hash = await bcrypt.hash(req.body.password, salt);
    const newUser = await User.create({
      username: req.body.username,
      email: req.body.email,
      password: hash,
      banned: false,
    });
    res.status(201).json(newUser);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

// Find user by username
function findByUserName(req, res) {
  User.findOne({ "username": req.params.username })
    .then(doc => {
      if (doc) {
        res.status(200).json(doc);
      } else {
        res.status(404).json({ error: "User not found" });
      }
    })
    .catch(err => {
      res.status(500).json({ error: err });
    });
}

// Authenticate user login
function authenticateUser(req, res) {
  User.findOne({ "username": req.body.username })
    .then(user => {
      bcrypt.compare(req.body.password, user.password, function (err, result) {
        if (result === true) {
          user.password = req.body.password;
          res.status(200).json(user);
        } else {
          res.status(403).json({ error: "Invalid password" });
        }
      });
    })
    .catch(err => {
      res.status(500).json({ error: err });
    });
}

// Toggle user role (admin/player)
async function toggleUserRole(req, res) {
  try {
    const { _id } = req.body;
    const user = await User.findById(_id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Toggle role
    user.role = user.role === 'admin' ? 'player' : 'admin';

    const updatedUser = await user.save();
    res.status(200).json(updatedUser);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

// Toggle user ban status
async function toggleUserBan(req, res) {
  try {
    const { _id } = req.body;
    const user = await User.findById(_id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    user.banned = !user.banned;
    const updatedUser = await user.save();
    res.status(200).json(updatedUser);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

// Update user password
function updatePassword(req, res) {
  bcrypt.genSalt(saltRounds, function (err, salt) {
    bcrypt.hash(req.body.password, salt, async function (err, hash) {
      if (err) {
        res.status(500).json({ error: err });
      } else {
        User.findOneAndUpdate(
          { username: req.body.username },
          { password: hash },
          { new: true }
        )
          .then(docs => {
            res.status(200).json(docs);
          })
          .catch(err => {
            res.status(500).json({ error: err });
          });
      }
    });
  });
}

// Update user information (username, email, password)
async function updateUser(req, res) {
  try {
    const { _id, username, email, password } = req.body;
    const updateFields = { username, email };

    if (password) {
      const salt = await bcrypt.genSalt(saltRounds);
      const hashedPassword = await bcrypt.hash(password, salt);
      updateFields.password = hashedPassword;
    }

    const updatedUser = await User.findByIdAndUpdate(_id, updateFields, { new: true });
    if (updatedUser) {
      res.status(200).json(updatedUser);
    } else {
      res.status(404).json({ error: 'User not found' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

// Delete user by username
async function deleteOnce(req, res) {
  try {
    const user = await User.findOneAndRemove({ "username": req.params.username });
    if (user) {
      res.status(200).json(user);
    } else {
      res.status(404).json({ error: "User not found" });
    }
  } catch (err) {
    res.status(500).json({ error: err });
  }
}

module.exports = {
  getAllUsers,
  addUser,
  findByUserName,
  authenticateUser,
  toggleUserRole,
  toggleUserBan,
  updatePassword,
  updateUser,
  deleteOnce
};
