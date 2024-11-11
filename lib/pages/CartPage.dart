import 'dart:io';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Cart.dart';

class CartPage extends StatefulWidget {
  CartPage();

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<Cart> cart = Future.value(Cart(items: [], userId: '')); // Use an empty Cart as a default value

  late String userId;

  // Initialize the userId and fetch the cart data
  Future<void> initializeUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('user_id') ?? '';
    if (userId.isNotEmpty) {
      setState(() {
        cart = fetchCart(userId); // Initialize with fetched data
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initializeUserId();
  }

  // Fetch Cart Data from API
  Future<Cart> fetchCart(String userId) async {
    final response = await http.get(Uri.parse('http://localhost:9090/api/cart/$userId'));

    if (response.statusCode == 200) {
      return Cart.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load cart');
    }
  }

  // Remove item from cart
  Future<void> removeItemFromCart(String productId) async {
    final response = await http.delete(
      Uri.parse('http://localhost:9090/api/cart/remove'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'userId': userId,
        'productId': productId,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        cart = fetchCart(userId);  // Refresh the cart data
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Product removed from cart'),
      ));
    } else {
      throw Exception('Failed to remove item from cart');
    }
  }

  // Remove all items from the cart
  Future<void> removeAllItemsFromCart() async {
    final response = await http.delete(
      Uri.parse('http://localhost:9090/api/cart/deleteAll'),
      headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({'userId': userId}),
    );

    if (response.statusCode == 200) {
      setState(() {
        cart = fetchCart(userId);  // Refresh the cart data
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('All products removed from cart'),
      ));
    } else {
      throw Exception('Failed to remove all items from cart');
    }
  }

  // Show a confirmation dialog for checkout with total price
  Future<void> showCheckoutDialog() async {
    double totalPrice = 0.0;
    final cartData = await cart;

    // Calculate total price
    for (var item in cartData.items) {
      totalPrice += item.productId.price * item.quantity;
    }

    // Show dialog with total price
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Checkout'),
          content: Text('Total Price: \$${totalPrice.toStringAsFixed(2)}\nAre you sure you want to purchase? This will clear your cart.'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Purchase'),
              onPressed: () {
                removeAllItemsFromCart();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: FutureBuilder<Cart>(
        future: cart,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.items.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.items.length,
                    itemBuilder: (context, index) {
                      var item = snapshot.data!.items[index];
                      return ListTile(
                        leading: item.productId.imageUrl.isNotEmpty
                            ? Image.file(
                          File(item.productId.imageUrl),
                          width: 50,
                          height: 50,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 50);
                          },
                        )
                            : const Icon(Icons.image, size: 50),
                        title: Text(item.productId.name),
                        subtitle: Text('Price: \$${item.productId.price}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Quantity: ${item.quantity}'),
                            IconButton(
                              icon: Icon(Icons.remove_shopping_cart),
                              onPressed: () => removeItemFromCart(item.productId.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Go to Checkout button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: showCheckoutDialog,
                    child: Text('Go to Checkout'),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Text('No items in cart.'));
          }
        },
      ),
    );
  }
}
