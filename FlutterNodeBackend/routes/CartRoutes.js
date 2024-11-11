import express from 'express';
import { addToCart, getCart, removeFromCart , removeAllProds} from '../controllers/CartController.js';

const router = express.Router();

// Route to add an item to the cart
router.post('/add', addToCart);

// Route to get the cart for a specific user
router.route('/:userId')
.get(getCart);
// Route to remove an item from the cart
router.delete('/remove', removeFromCart);
router.route('/deleteAll')
.delete(removeAllProds);

export default router;
