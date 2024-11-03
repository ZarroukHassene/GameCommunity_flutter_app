import User from '../models/user.js';

const usercontroller = {
    //Get user by ID
    getUserById: async (req, res) => {
        try {
            const { userId } = req.params;
            const user = await User.findById(userId);
            if (!user) {
                return res.status(404).json({ message: 'User not found' });
            }
            res.status(200).json(user);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    },
    GetUserByUsername: async (req, res) => {
        try {
            const { username } = req.params;
            //Print params
            console.log(username);
            const user = await User.findOne({ username:
                username });
            if (!user) {
                return res.status(404).json({ message: 'User not found' });
            }
            res.status(200).json(user);
        } catch (error) {
            res.status(500).json({ message: error.message });
        }
    }
};

export default usercontroller;