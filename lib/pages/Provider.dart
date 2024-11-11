import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products => _products;

  // Add a product to both local state and the backend
  Future<void> addProduct(Product product) async {
    print("aaa " + product.name);
    try {
      final url = Uri.parse('http://10.0.2.2:9090/api/products/'); // Update with your API URL

      // Send POST request to the backend
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': product.name,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );

      if (response.statusCode == 201) {
        // If the product is created successfully, add it to the local list
        _products.add(product);
        notifyListeners();
        print('Product created successfully');
      } else {
        print('Failed to create product');
      }
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  // Remove a product both locally and from the backend
  Future<void> removeProduct(String id) async {
    try {
      final url = Uri.parse('http://10.0.2.2:9090/api/products/$id'); // Update with your API URL

      final response = await http.delete(url);

      if (response.statusCode == 200) {
        // If the product is deleted successfully from the backend, remove it from the local list
        _products.removeWhere((product) => product.id == id);
        notifyListeners();
        print('Product removed successfully');
      } else {
        print('Failed to remove product');
      }
    } catch (e) {
      print('Error removing product: $e');
    }
  }
  Future<void> fetchProducts() async {

    try {
      final url = Uri.parse('http://10.0.2.2:9090/api/products'); // Update with your API URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> productData = json.decode(response.body);
        print("im fetching ");

        // Parse each item in the productData list to a Product object
        _products = productData.map((data) => Product.fromJson(data)).toList();


       // print('Products loaded successfully: ${_products[3].name}');
      } else {
        print('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');

    }
  }

// Optionally, you can add a method to save products locally, such as in SharedPreferences,
// so they persist across app restarts. However, fetching from the API every time is an easy option.
}