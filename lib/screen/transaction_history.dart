import 'package:flutter/material.dart';

import 'rental_data.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  String formatRupiah(int price) {
    return 'Rp${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
  }

  String formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  Color statusColor(String status) {
    if (status == 'Approved') return Colors.green;
    if (status == 'Rejected') return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final rentals = RentalData.rentals.reversed.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 20, 20, 20),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: black),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Transaction History',
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
                  ? const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 65,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 15),
                          Text(
                            'No Transactions Yet',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: black,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Your transaction history will appear here.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      itemCount: rentals.length,
                      itemBuilder: (context, index) {
                        final rental = rentals[index];
                        final product =
                            rental['product'] as Map<String, dynamic>;
                        final status =
                            rental['status']?.toString() ?? 'Pending';

                        final startDate = rental['startDate'] as DateTime;
                        final endDate = rental['endDate'] as DateTime;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor(status)
                                          .withValues(alpha: 0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      status,
                                      style: TextStyle(
                                        color: statusColor(status),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              _infoRow(
                                'Rental Date',
                                '${formatDate(startDate)} - ${formatDate(endDate)}',
                              ),
                              _infoRow(
                                'Duration',
                                '${rental['rentalDays']} day(s)',
                              ),
                              _infoRow(
                                'Delivery',
                                rental['deliveryMethod'].toString(),
                              ),
                              _infoRow(
                                'Payment',
                                rental['paymentMethod'].toString(),
                              ),
                              const Divider(height: 22),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Payment',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: black,
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
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: black,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
