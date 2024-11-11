import Cart from '../models/Cart.js';
// Add product to cart
export const addToCart = async (req, res) => {
  try {
    const { userId, productId } = req.body;

    // Fetch the user's cart
    let cart = await Cart.findOne({ userId });

    if (cart) {
      // If cart exists, check if product is already in the cart
      const itemIndex = cart.items.findIndex(item => item.productId.toString() === productId.toString());

      if (itemIndex > -1) {
        // If the product exists, update the quantity
        cart.items[itemIndex].quantity += 1;
      } else {
        // If the product does not exist, add new item
        cart.items.push({ productId , quantity : 1  });
      }
    } else {
      // If no cart exists, create a new cart
      cart = new Cart({
        userId,
        items: [{ productId, quantity : 1 }]
      });
    }

    // Save the updated cart
    await cart.save();

    // Respond with the updated cart
    res.status(200).json(cart);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "An error occurred while adding the product to the cart" });
  }
};

// Get cart items for a user
export const getCart = async (req, res) => {
  try {
    const { userId } = req.params;
    const cart = await Cart.findOne({ userId }).populate('items.productId');

    if (!cart) return res.status(404).json({ message: 'Cart not found' });

    res.status(200).json(cart);
  } catch (error) {
    res.status(500).json({ message: 'Error retrieving cart', error });
  }
};

// Remove item from cart (reduce quantity or remove product)
export const removeFromCart = async (req, res) => {
  try {
    const { userId, productId } = req.body;
    const cart = await Cart.findOne({ userId });

    if (cart) {
      // Find the index of the product in the cart items
      const itemIndex = cart.items.findIndex(item => item.productId.toString() === productId.toString());

      if (itemIndex > -1) {
        // If the product is found, reduce the quantity
        if (cart.items[itemIndex].quantity > 1) {
          cart.items[itemIndex].quantity -= 1; // Decrease the quantity by 1
        } else {
          // If the quantity is 1, remove the item from the cart
          cart.items.splice(itemIndex, 1);
        }
      }

      // Save the updated cart
      await cart.save();
      res.status(200).json(cart);
    } else {
      res.status(404).json({ message: 'Cart not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error removing item from cart', error });
  }
};




// Remove all products from cart
export const removeAllProds = async (req, res) => {
  try {
    const { userId } = req.body;
    const cart = await Cart.findOne({ userId });

    if (cart) {
      // Clear all items from the cart
      cart.items = [];
      await cart.save();
      res.status(200).json({ message: 'All products removed from cart', cart });
    } else {
      res.status(404).json({ message: 'Cart not found' });
    }
  } catch (error) {
    res.status(500).json({ message: 'Error clearing the cart', error });
  }
};
