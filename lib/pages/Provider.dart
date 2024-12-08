import 'dart:math';

import 'package:flutter/material.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  List<Product> _cartItems = [];
  List<Product> get products => _products;
  List<Product> get filteredProducts => _filteredProducts;
  List<Product> get cartItems => _cartItems;
  List<Product> _cases = []; // List to store all created cases


  // Getter for cases
  List<Product> get cases => _cases;

  // Add a product to both local state and the backend
  Future<void> addToCart(Product product) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final url = Uri.parse('http://10.0.2.2:9090/api/cart/add'); // Update with your API URL

      // Send POST request to the backend
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "userId": prefs.getString('user_id'),
          "productId": product.id,
          "quantity": 1, // Explicitly add quantity here
        }),
      );

      if (response.statusCode == 200) {
        // If the product is added to the cart successfully
        print('Product added to cart successfully');
      } else {
        print('Failed to add product to cart');
      }
    } catch (e) {
      print('Error adding product: $e');
    }

    // Add the product to the local cart items (for immediate UI update)
    _cartItems.add(product);
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
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

  // Fetch products from the API
  // Fetch products from the API
  Future<void> fetchProducts() async {
    try {
      final url = Uri.parse('http://10.0.2.2:9090/api/products'); // Update with your API URL
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> productData = json.decode(response.body);
        _products = productData.map((data) => Product.fromJson(data)).toList();
        _filteredProducts = List.from(_products); // Initialize filtered list with all products
        notifyListeners();
      } else {
        print('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }void filterProducts(String searchTerm, double minPrice, double maxPrice) {
    print('Filtering with search term: $searchTerm, Price range: \$${minPrice} - \$${maxPrice}'); // Debugging line

    if (searchTerm.isEmpty && minPrice == 0 && maxPrice == 100) {
      // If no filter is applied, reset to all products
      _filteredProducts = List.from(_products);
    } else {
      _filteredProducts = _products.where((product) {
        final matchesSearchTerm = product.name.toLowerCase().contains(searchTerm.toLowerCase());
        final matchesPriceRange = product.price >= minPrice && product.price <= maxPrice;

        // Log the matches to check the filtering logic
        print('Checking product: ${product.name}');
        print('Matches search: $matchesSearchTerm, Matches price range: $matchesPriceRange');

        return matchesSearchTerm && matchesPriceRange;
      }).toList();
    }

    print('Filtered products count: ${_filteredProducts.length}'); // Debugging line to show the filtered list length
    notifyListeners();
  }// Method to create a case with selected products
  Product? createRandomCase(List<Product> selectedProducts) {
    if (_products.isNotEmpty) {
      final randomProduct = _products[Random().nextInt(_products.length)];
      return randomProduct;
    }
    return null;
  }


}

