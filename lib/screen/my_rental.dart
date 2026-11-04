import 'package:flutter/material.dart';

import 'rental_data.dart';

class MyRentalsScreen extends StatelessWidget {
  const MyRentalsScreen({super.key});

  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String formatRupiah(int price) {
    final result = price.toString();
    final formatted = result.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return 'Rp$formatted';
  }

  Color statusColor(String status) {
    switch (status) {
      case 'Approved':
        return Colors.green;
      case 'Rejected':
        return Colors.red;
      default:
        return orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final rentals = RentalData.rentals;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'My Rentals',
          style: TextStyle(color: black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: rentals.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 75,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'No Rentals Yet',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Your rental requests will appear here.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: rentals.length,
              itemBuilder: (context, index) {
                final rental = rentals[index];
                final product = rental['product'] as Map<String, dynamic>;

                final status = rental['status']?.toString() ?? 'Pending';
                final color = statusColor(status);

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              product['name'].toString(),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      detailRow(
                        'Start Date',
                        formatDate(rental['startDate'] as DateTime),
                      ),

                      detailRow(
                        'End Date',
                        formatDate(rental['endDate'] as DateTime),
                      ),

                      detailRow('Duration', '${rental['rentalDays']} day(s)'),

                      detailRow(
                        'Delivery',
                        rental['deliveryMethod'].toString(),
                      ),

                      detailRow('Payment', rental['paymentMethod'].toString()),

                      const Divider(height: 25),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total Payment',
                            style: TextStyle(
                              color: black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            formatRupiah((rental['totalPrice'] as num).toInt()),
                            style: const TextStyle(
                              color: orange,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Text(
            value,
            style: const TextStyle(
              color: black,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
