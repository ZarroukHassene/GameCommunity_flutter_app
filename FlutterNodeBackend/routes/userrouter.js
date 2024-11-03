import express from 'express';

import  usercontroller  from '../controllers/usercontroller.js';

const router = express.Router();

//Find user by username
router.get('/:username', usercontroller.GetUserByUsername);

export default router;