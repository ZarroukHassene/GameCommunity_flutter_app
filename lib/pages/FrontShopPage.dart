import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
import 'product.dart'; // Your product model file
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'CartPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrontShopPage extends StatefulWidget {
  const FrontShopPage({Key? key}) : super(key: key);

  @override
  State<FrontShopPage> createState() => _FrontShopState();
}

class _FrontShopState extends State<FrontShopPage> {
  late String ID;
  // Fetch products when the page loads
  @override
  void initState() {
    super.initState();
    // Fetch the products from the backend when the page loads
    Provider.of<ProductProvider>(context, listen: false).fetchProducts();
  }

  // Function to handle image uploading
  Future<void> _uploadImage(BuildContext context, Product product) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      // Update the product's imageUrl with the selected image path
      setState(() {
        product.imageUrl = pickedImage.path;
      });

      // Notify the ProductProvider to rebuild the UI
      Provider.of<ProductProvider>(context, listen: false).addProduct(product);
    }
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductProvider>(  // Consumer listens to changes in ProductProvider
          builder: (context, productProvider, child) {
            // Fetch products each time the Consumer is built
            productProvider.fetchProducts();
            return GridView.builder(
              itemCount: productProvider.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.7,
              ),
              itemBuilder: (context, index) {
                final product = productProvider.products[index];
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
                                : const Icon(Icons.image, size: 50), // Placeholder if no image
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
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
print("prod that should be added to cart "+product.id.toString());
                            // Add item to cart
                            Provider.of<ProductProvider>(context, listen: false)
                                .addToCart(product); // Implement this method in your ProductProvider
                          },
                          child: const Text('Add to Cart'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
