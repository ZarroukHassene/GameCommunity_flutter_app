import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
import 'product.dart'; // Your product model file
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'CartPage.dart';

class FrontShopPage extends StatefulWidget {
  const FrontShopPage({Key? key}) : super(key: key);

  @override
  State<FrontShopPage> createState() => _FrontShopState();
}

class _FrontShopState extends State<FrontShopPage> {
  TextEditingController _searchController = TextEditingController();
  double _minPrice = 0;
  double _maxPrice = 100; // Set a max price initially

  // Function to handle image uploading
  Future<void> _uploadImage(BuildContext context, Product product) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        product.imageUrl = pickedImage.path;
      });
      Provider.of<ProductProvider>(context, listen: false).addProduct(product);
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch the products when the page loads
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  // Function to handle search and price filtering
  void _filterProducts() {
    Provider.of<ProductProvider>(context, listen: false).filterProducts(
      _searchController.text,
      _minPrice,
      _maxPrice,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage()),
              );
            },
          ),
        ],
      ),

      backgroundColor: const Color(0xFF4B4376),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search and Price Filter Row
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Search by Name',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        _filterProducts(); // Trigger filter when search changes
                      },
                    ),
                  ),
                ),
                // Price Range Filter
                Column(
                  children: [
                    const Text(
                      'Price Range',
                      style: TextStyle(color: Colors.white),
                    ),
                    // Display the current price range above the slider
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        '\$${_minPrice.toStringAsFixed(0)} - \$${_maxPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    RangeSlider(
                      values: RangeValues(_minPrice, _maxPrice),
                      min: 0,
                      max: 1000, // Set to 1000 as your requested max price
                      divisions: 100, // Optional: to show divisions for better precision
                      activeColor: Colors.blue, // Slider track color and thumb color
                      inactiveColor: Colors.blue.withOpacity(0.3), // Inactive track color
                      onChanged: (RangeValues values) {
                        setState(() {
                          _minPrice = values.start;
                          _maxPrice = values.end;
                        });
                        _filterProducts(); // Trigger filter when price changes
                      },
                    )


                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Displaying products after filtering
            Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                return Expanded(
                  child: GridView.builder(
                    itemCount: productProvider.filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      final product = productProvider.filteredProducts[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _uploadImage(context, product),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: product.imageUrl.isNotEmpty
                                      ? Image.file(
                                    File(product.imageUrl),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.broken_image, size: 50);
                                    },
                                  )
                                      : const Icon(Icons.image, size: 50),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                '\$${product.price}',
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Add item to cart
                                  Provider.of<ProductProvider>(context, listen: false)
                                      .addToCart(product);
                                },
                                child: const Text('Add to Cart'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
