import 'dart:ffi';

class Product {
  final String id;
  final String name;
  final double price;
  String imageUrl; // Remove 'final' so it's mutable

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  // To convert the product to a map (useful for saving in databases)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // To create a product from a map (useful when retrieving from databases)
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: map['price'],
      imageUrl: map['imageUrl'],
    );
  }

  // To create a product from JSON (useful for API responses)
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '', // Provide a default empty string if null
      name: json['name'] ?? '', // Provide a default empty string if null
      price: (json['price'] as num?)?.toDouble() ?? 0.0, // Ensure price is a double with a default of 0.0
      imageUrl: json['imageUrl'], // imageUrl is nullable
    );
  }
}
