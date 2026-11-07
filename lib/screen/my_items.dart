import 'package:flutter/material.dart';

import 'product_data.dart';

import 'dart:io';

import 'package:image_picker/image_picker.dart';

class MyItemsScreen extends StatefulWidget {
  const MyItemsScreen({super.key});

  @override
  State<MyItemsScreen> createState() => _MyItemsScreenState();
}

class _MyItemsScreenState extends State<MyItemsScreen> {
  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  void editStock(int index) {
    final controller = TextEditingController(
      text: ProductData.products[index]['stock'].toString(),
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Stock'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Stock Quantity',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final newStock = int.tryParse(controller.text);

                if (newStock == null || newStock < 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Enter a valid stock quantity!'),
                    ),
                  );
                  return;
                }

                setState(() {
                  ProductData.products[index]['stock'] = newStock;
                  ProductData.products[index]['isAvailable'] = newStock > 0;
                });

                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void editItem(int index) {
    final product = ProductData.products[index];

    final nameController = TextEditingController(text: product['name']);
    final categoryController = TextEditingController(text: product['category']);
    final priceController = TextEditingController(text: product['price']);
    final locationController = TextEditingController(text: product['location']);

    File? selectedImage;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final currentImage = selectedImage?.path ?? product['image'];

            Widget imagePreview;

            if (currentImage.toString().startsWith('http')) {
              imagePreview = Image.network(
                currentImage,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              );
            } else {
              imagePreview = Image.file(
                File(currentImage),
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              );
            }

            return AlertDialog(
              title: const Text('Edit Item'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final XFile? image = await ImagePicker().pickImage(
                          source: ImageSource.gallery,
                        );

                        if (image != null) {
                          setDialogState(() {
                            selectedImage = File(image.path);
                          });
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3E8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            imagePreview,
                            Container(
                              color: Colors.black.withValues(alpha: 0.35),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Change Photo',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 18),

                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Item Name'),
                    ),

                    TextField(
                      controller: categoryController,
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),

                    TextField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Price per Day',
                      ),
                    ),

                    TextField(
                      controller: locationController,
                      decoration: const InputDecoration(labelText: 'Location'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty ||
                        categoryController.text.trim().isEmpty ||
                        priceController.text.trim().isEmpty ||
                        locationController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please complete all item details!'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      ProductData.products[index]['name'] = nameController.text
                          .trim();

                      ProductData.products[index]['category'] =
                          categoryController.text.trim();

                      ProductData.products[index]['price'] = priceController
                          .text
                          .trim();

                      ProductData.products[index]['location'] =
                          locationController.text.trim();

                      if (selectedImage != null) {
                        ProductData.products[index]['image'] =
                            selectedImage!.path;
                      }
                    });

                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Save Changes'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void deleteItem(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      setState(() {
        ProductData.products.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Item deleted successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ProductData.products;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Items',
          style: TextStyle(color: black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: black),
      ),
      body: products.isEmpty
          ? const Center(child: Text('You have no items yet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                final isAvailable = product['isAvailable'] == true;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: product['image'].toString().startsWith('http')
                            ? Image.network(
                                product['image'],
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  );
                                },
                              )
                            : Image.file(
                                File(product['image']),
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 90,
                                    height: 90,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      Icons.image_not_supported,
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'],
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product['category'],
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              'Rp${product['price']}/day',
                              style: const TextStyle(
                                color: orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              isAvailable ? 'Available' : 'Not Available',
                              style: TextStyle(
                                color: isAvailable ? Colors.green : Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),

                            Row(
                              children: [
                                const Text(
                                  'Stock:',
                                  style: TextStyle(fontSize: 12),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${product['stock']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),

                                PopupMenuButton<String>(
                                  icon: const Icon(
                                    Icons.more_vert,
                                    color: Colors.grey,
                                  ),
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      editItem(index);
                                    } else if (value == 'stock') {
                                      editStock(index);
                                    } else if (value == 'delete') {
                                      deleteItem(index);
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'edit',
                                      child: Row(
                                        children: [
                                          Icon(Icons.edit_outlined, size: 19),
                                          SizedBox(width: 10),
                                          Text('Edit Item'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'stock',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.inventory_2_outlined,
                                            size: 19,
                                          ),
                                          SizedBox(width: 10),
                                          Text('Update Stock'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'delete',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            size: 19,
                                            color: Colors.red,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            'Delete Item',
                                            style: TextStyle(color: Colors.red),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
