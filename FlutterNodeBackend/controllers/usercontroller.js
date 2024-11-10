
import User from '../models/user.js';
import { validationResult } from 'express-validator';
import bcrypt from 'bcrypt';





const saltRounds = 10;

export function getAll(req,res){
  User
  .find({})
  .then(docs=>{
      res.status(200).json(docs);
  })
  .catch(err=>{
      res.status(500).json({error:err});
  });
};

export async function toggleUserRole(req, res) {
  try {
    const { _id } = req.body;

    // Find the user by _id
    const user = await User.findById(_id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Toggle role
    user.role = user.role === 'admin' ? 'player' : 'admin';

    // Save the updated user
    const updatedUser = await user.save();
    res.status(200).json(updatedUser);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}


export async function toggleUserBan(req, res) {
  try {
    const { _id } = req.body;

    // Find the user by _id
    const user = await User.findById(_id);
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    // Toggle the banned status
    user.banned = !user.banned;

    // Save the updated user
    const updatedUser = await user.save();
    res.status(200).json(updatedUser);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

export function updatePassword(req, res) {
  bcrypt.genSalt(saltRounds, function (err, salt) {
    bcrypt.hash(req.body.password, salt, async function (err, hash) {
      if (err) {
        res.status(500).json({ error: err });
      } else {
        User.findOneAndUpdate(
          { username: req.body.username }, // Finding the document by username
          { password: hash }, // Updating password field
          { new: true } // To return the updated document
        )
          .then((docs) => {
            res.status(200).json(docs);
          })
          .catch((err) => {
            res.status(500).json({ error: err });
          });
      }
    });
  });
}

export async function updateUser(req, res) {
  try {
    const { _id, username, email, password } = req.body;

    const updateFields = { username, email};

    // If password is provided, hash it and add to update fields
    if (password) {
      const salt = await bcrypt.genSalt(saltRounds);
      const hashedPassword = await bcrypt.hash(password, salt);
      updateFields.password = hashedPassword;
    }

    // Update user by _id and return the updated document
    const updatedUser = await User.findByIdAndUpdate(
      _id,
      updateFields,
      { new: true } // Return the updated document
    );
    if (updatedUser) {
      res.status(200).json(updatedUser);
    } else {
      res.status(404).json({ error: 'User not found' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
}

export async function AddOnce(req, res) {
  if (!validationResult(req).isEmpty()) {
    res.status(400).json({ error: validationResult(req).array() });
    return;
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
      banned:false
    });
    res.status(200).json(newUser);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};


export function findByUserName(req, res) {
  User
    .findOne({"username": req.params.username})
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
};




export async function getOnce(req, res) {
  try {
    // Find the user by username
    const user = await User.findOne({ "username": req.params.username });

    if (user) {
      // Create a plain object from the Mongoose document
      const userWithPassword = user.password;

      // Make sure to include the password explicitly, if necessary
      // In a secure environment, you may want to log the password for debugging only
      res.status(200).json(userWithPassword);
    } else {
      res.status(404).json({ "error": "User not found" });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ "error": "Internal server error" });
  }
}



export function getOnceById(req,res){
    User
    .findById(req.params.id)
    .then(doc=>{
        res.status(200).json(doc);
    })
    .catch(err=>{
        res.status(500).json({error:err});
    });
}

export async function deleteOnce(req,res){
    User.findOneAndRemove({"username":req.params.username})
    .then(doc=>{
        res.status(200).json(doc);
    })
    .catch(err=>{
        res.status(500).json({error:err});
    });

}

export function Sauthentifier(req,res){
    User.findOne({"username":req.body.username})
    .then(user=>{
        bcrypt.compare(req.body.password, user.password, function(err, result) {
            if (result === true) {
              user.password = req.body.password
              res.status(200).json(user);
            } else {
              res.status(403).json({"erreur":"invalid password"});
            }
          });
    })
    .catch(err=>{
        res.status(500).json({error:err});
    });
}


