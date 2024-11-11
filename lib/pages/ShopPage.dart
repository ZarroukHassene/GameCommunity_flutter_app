import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider.dart';
import 'product.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert'; // For encoding data to JSON

class ShopPage extends StatefulWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<ProductProvider>(  // Consumer listens to changes in ProductProvider
          builder: (context, productProvider, child) {
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
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          productProvider.removeProduct(product.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Show dialog to create a new product
          showDialog(
            context: context,
            builder: (context) => ProductCreateDialog(),
          );
        },
        label: const Text('Add Product'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

// ProductCreateDialog and the rest of the code remains unchanged

class ProductCreateDialog extends StatefulWidget {
  @override
  _ProductCreateDialogState createState() => _ProductCreateDialogState();
}

class _ProductCreateDialogState extends State<ProductCreateDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  File? _image; // Store the selected image file
  final ImagePicker _picker = ImagePicker(); // ImagePicker instance

  // Method to pick an image from the gallery
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path); // Store the selected image file
        });
      } else {
        // User canceled the picker
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Product Name'),
          ),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Price'),
          ),
          // Button to trigger image picking
          ElevatedButton(
            onPressed: _pickImage,
            child: const Text('Pick Image'),
          ),
          // Show the selected image (if any)
          if (_image != null)
            Image.file(
              _image!,
              height: 100,
              width: 100,
              fit: BoxFit.cover,
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final product = Product(
              id: DateTime.now().toString(),
              name: _nameController.text,
              price: double.tryParse(_priceController.text) ?? 0.0,
              imageUrl: _image?.path ?? '', // Use the selected image path
            );

            Provider.of<ProductProvider>(context, listen: false).addProduct(product);
            Navigator.of(context).pop();
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
