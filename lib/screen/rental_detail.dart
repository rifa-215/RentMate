import 'dart:io';

import 'package:flutter/material.dart';

class RentalDetailScreen extends StatelessWidget {
  final Map<String, dynamic> rental;

  const RentalDetailScreen({super.key, required this.rental});

  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  String formatRupiah(int price) {
    return 'Rp${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
  }

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = rental['product'] as Map<String, dynamic>;

    final startDate = rental['startDate'] as DateTime?;
    final endDate = rental['endDate'] as DateTime?;

    final imagePath = product['image']?.toString() ?? '';
    final status = rental['status']?.toString() ?? 'Pending';

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: black),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Rental Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        height: 190,
                        width: double.infinity,
                        child: imagePath.startsWith('http')
                            ? Image.network(
                                imagePath,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const Icon(Icons.image_not_supported),
                              )
                            : imagePath.isNotEmpty
                            ? Image.file(
                                File(imagePath),
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) =>
                                    const Icon(Icons.image_not_supported),
                              )
                            : const Icon(Icons.image_not_supported),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      product['name']?.toString() ?? '-',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      product['category']?.toString() ?? '-',
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),

                    const SizedBox(height: 20),

                    sectionTitle('Rental Information'),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Column(
                        children: [
                          detailRow(
                            'Start Date',
                            startDate == null ? '-' : formatDate(startDate),
                          ),
                          detailRow(
                            'End Date',
                            endDate == null ? '-' : formatDate(endDate),
                          ),
                          detailRow(
                            'Duration',
                            '${rental['rentalDays'] ?? 0} day(s)',
                          ),
                          detailRow(
                            'Delivery Method',
                            rental['deliveryMethod']?.toString() ?? '-',
                          ),
                          detailRow(
                            'Payment Method',
                            rental['paymentMethod']?.toString() ?? '-',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    sectionTitle('Payment Summary'),
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF3E8),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: detailRow(
                        'Total Rental Price',
                        formatRupiah(
                          (rental['totalPrice'] as num?)?.toInt() ?? 0,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    sectionTitle('Request Status'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          color: status == 'Approved'
                              ? Colors.green
                              : status == 'Rejected'
                              ? Colors.red
                              : orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    sectionTitle('Customer Information'),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F8F8),
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Column(
                        children: [
                          detailRow(
                            'Full Name',
                            rental['customerName']?.toString() ?? '-',
                          ),
                          detailRow(
                            'Phone Number',
                            rental['customerPhone']?.toString() ?? '-',
                          ),
                          detailRow(
                            'Address',
                            rental['customerAddress']?.toString() ?? '-',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
