import 'package:flutter/material.dart';

import 'rental_data.dart';
import 'review_screen.dart';

class MyRentalsScreen extends StatefulWidget {
  final VoidCallback onBack;

  const MyRentalsScreen({super.key, required this.onBack});

  @override
  State<MyRentalsScreen> createState() => _MyRentalsScreenState();
}

class _MyRentalsScreenState extends State<MyRentalsScreen> {
  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  String formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String formatRupiah(int price) {
    return 'Rp${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
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

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
            child: Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.arrow_back, color: black),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                const Text(
                  'My Rentals',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: rentals.isEmpty
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
                                    color: color.withValues(alpha: 0.12),
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
                            detailRow(
                              'Duration',
                              '${rental['rentalDays']} day(s)',
                            ),
                            detailRow(
                              'Delivery',
                              rental['deliveryMethod'].toString(),
                            ),
                            detailRow(
                              'Payment',
                              rental['paymentMethod'].toString(),
                            ),
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
                                  formatRupiah(
                                    (rental['totalPrice'] as num).toInt(),
                                  ),
                                  style: const TextStyle(
                                    color: orange,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                if (status == 'Approved' &&
                                    rental['hasReviewed'] != true) ...[
                                  const SizedBox(height: 15),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ReviewScreen(
                                              productName: product['name']
                                                  .toString(),
                                              rentalIndex: index,
                                            ),
                                          ),
                                        );

                                        setState(() {});
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: orange,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Give Review',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                                if (rental['hasReviewed'] == true) ...[
                                  const SizedBox(height: 15),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.check_circle,
                                        color: Colors.green,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Reviewed',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${rental['rating']} / 5 ⭐',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                            if (status == 'Approved' &&
                                rental['hasReviewed'] != true) ...[
                              const SizedBox(height: 15),
                              SizedBox(
                                width: double.infinity,
                                height: 45,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ReviewScreen(
                                          productName: product['name']
                                              .toString(),
                                          rentalIndex: index,
                                        ),
                                      ),
                                    );

                                    setState(() {});
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: orange,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    'Give Review',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],

                            if (rental['hasReviewed'] == true) ...[
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Reviewed',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${rental['rating']} / 5 ⭐',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
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
