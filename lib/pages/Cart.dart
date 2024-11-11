import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'product.dart';
// Define the Cart, Item, and Product classes as previously defined
class Cart {
  final String userId; // Assuming userId is a string type in Flutter
  final List<Item> items; // A list of Item objects

  Cart({
    required this.userId,
    required this.items,
  });

  // FromJson constructor
  factory Cart.fromJson(Map<String, dynamic> json) {
    var itemsJson = json['items'] as List;
    List<Item> items = itemsJson.map((itemJson) => Item.fromJson(itemJson)).toList();

    return Cart(
      userId: json['userId'],
      items: items,
    );
  }
}

class Item {
  final Product productId; // A Product object
  final int quantity;

  Item({
    required this.productId,
    required this.quantity,
  });

  // FromJson constructor
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      productId: Product.fromJson(json['productId']),
      quantity: json['quantity'] ?? 1, // Default quantity to 1 if not provided
    );
  }
}

