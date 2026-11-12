import 'dart:io';

import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'rental_request.dart';
import 'rental_data.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, dynamic> product;

  const ProductDetailScreen({super.key, required this.product});

  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  Widget buildProductImage() {
    final image = product['image'].toString();

    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: double.infinity,
        height: 280,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return imagePlaceholder();
        },
      );
    }

    return Image.file(
      File(image),
      width: double.infinity,
      height: 280,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return imagePlaceholder();
      },
    );
  }

  Widget imagePlaceholder() {
    return Container(
      height: 280,
      color: const Color(0xFFFFF3E8),
      child: const Center(
        child: Icon(Icons.image_not_supported, color: orange, size: 50),
      ),
    );
  }

  Widget buildStars(double rating, {double size = 20}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating.round() ? Icons.star : Icons.star_border,
          color: orange,
          size: size,
        );
      }),
    );
  }

  Widget buildCustomerReviews() {
    final productReviews = RentalData.rentals.where((rental) {
      final reviewedProduct = rental['product'] as Map<String, dynamic>?;

      return rental['hasReviewed'] == true &&
          reviewedProduct?['name'] == product['name'];
    }).toList();

    final averageRating = productReviews.isEmpty
        ? 0.0
        : productReviews.fold<double>(
                0,
                (sum, review) =>
                    sum + ((review['rating'] as num?)?.toDouble() ?? 0),
              ) /
              productReviews.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customer Reviews',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: black,
          ),
        ),

        const SizedBox(height: 15),

        if (productReviews.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Text(
                  averageRating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildStars(averageRating, size: 20),
                    const SizedBox(height: 4),
                    Text(
                      '${productReviews.length} review(s)',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          ...productReviews.map((review) {
            final rating = (review['rating'] as num?)?.toDouble() ?? 0;

            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F8F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 17,
                        backgroundColor: Color(0xFFFFF3E8),
                        child: Icon(Icons.person, color: orange, size: 19),
                      ),

                      const SizedBox(width: 10),

                      const Expanded(
                        child: Text(
                          'Customer',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: black,
                          ),
                        ),
                      ),

                      buildStars(rating, size: 16),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Text(
                    review['review']?.toString() ?? '',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            );
          }),
        ] else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Column(
              children: [
                Icon(Icons.rate_review_outlined, size: 40, color: Colors.grey),
                SizedBox(height: 10),
                Text(
                  'No Reviews Yet',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Be the first to review this product!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Product Detail',
          style: TextStyle(color: black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PRODUCT IMAGE
            buildProductImage(),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CATEGORY
                  Text(
                    product['category'].toString(),
                    style: const TextStyle(
                      color: orange,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // PRODUCT NAME
                  Text(
                    product['name'].toString(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // LOCATION
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        product['location'].toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Divider(),

                  const SizedBox(height: 15),

                  // AVAILABILITY
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: product['isAvailable'] == true
                          ? Colors.green.shade50
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          product['isAvailable'] == true
                              ? Icons.check_circle
                              : Icons.cancel,
                          size: 16,
                          color: product['isAvailable'] == true
                              ? Colors.green
                              : Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          product['isAvailable'] == true
                              ? 'Available'
                              : 'Not Available',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: product['isAvailable'] == true
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 15),

                  // PRICE
                  const Text(
                    'Rental Price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),

                  const SizedBox(height: 8),

                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: orange,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(text: 'Rp${product['price']}'),
                        const TextSpan(
                          text: ' / day',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Divider(),

                  const SizedBox(height: 15),

                  // DESCRIPTION
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    '${product['name']} is available for rent '
                    'in ${product['location']}. '
                    'Enjoy a convenient rental experience with RentMate.',
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Divider(),

                  const SizedBox(height: 20),

                  // CUSTOMER REVIEWS
                  buildCustomerReviews(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),

      // BOTTOM BUTTONS
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // CHAT BUTTON
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            productName: product['name'].toString(),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat Seller'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: orange,
                      side: const BorderSide(color: orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // RENT BUTTON
              Expanded(
                child: SizedBox(
                  height: 55,
                  child: ElevatedButton(
                    onPressed: product['isAvailable'] == true
                        ? () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    RentalRequestScreen(product: product),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: orange,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Rent Now',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
