import 'package:flutter/material.dart';

import 'rental_data.dart';
import 'rental_detail.dart';

class OwnerRequestsScreen extends StatefulWidget {
  const OwnerRequestsScreen({super.key});

  @override
  State<OwnerRequestsScreen> createState() => _OwnerRequestsScreenState();
}

class _OwnerRequestsScreenState extends State<OwnerRequestsScreen> {
  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  String selectedFilter = 'All';

  final List<String> filters = ['All', 'Pending', 'Approved', 'Rejected'];

  String formatRupiah(int price) {
    return 'Rp${price.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')}';
  }

  void updateRentalStatus(int index, String status) {
    setState(() {
      RentalData.updateStatus(index, status);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          status == 'Approved'
              ? 'Rental request approved!'
              : 'Rental request rejected!',
        ),
        backgroundColor: status == 'Approved' ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rentals = RentalData.rentals.asMap().entries.where((entry) {
      if (selectedFilter == 'All') {
        return true;
      }

      return entry.value['status'] == selectedFilter;
    }).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 15),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: black, size: 21),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Owner Requests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                ),
              ],
            ),
          ),

          // FILTER
          SizedBox(
            height: 32,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final filter = filters[index];
                final isSelected = selectedFilter == filter;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedFilter = filter;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 13,
                      vertical: 6,
                    ),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isSelected ? orange : const Color(0xFFFFF3E8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected ? Colors.white : black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 15),

          // RENTAL LIST
          Expanded(
            child: rentals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.inbox_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'No Requests Yet',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: black,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Rental requests will appear here.',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
                    itemCount: rentals.length,
                    itemBuilder: (context, index) {
                      final rentalEntry = rentals[index];
                      final rental = rentalEntry.value;
                      final originalIndex = rentalEntry.key;

                      final product = rental['product'] as Map<String, dynamic>;

                      final status = rental['status']?.toString() ?? 'Pending';

                      return Container(
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
                            // PRODUCT NAME
                            Text(
                              product['name'].toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),

                            const SizedBox(height: 10),

                            // RENTAL DURATION
                            Text(
                              'Rental Duration: ${rental['rentalDays']} day(s)',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 7),

                            // TOTAL
                            Text(
                              'Total: ${formatRupiah((rental['totalPrice'] as num).toInt())}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: orange,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // VIEW DETAILS
                            SizedBox(
                              width: double.infinity,
                              height: 35,
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RentalDetailScreen(rental: rental),
                                    ),
                                  ).then((_) {
                                    setState(() {});
                                  });
                                },
                                icon: const Icon(
                                  Icons.visibility_outlined,
                                  size: 16,
                                ),
                                label: const Text(
                                  'View Details',
                                  style: TextStyle(fontSize: 12),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: orange,
                                  side: const BorderSide(color: orange),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(9),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 10),

                            // APPROVE AND REJECT
                            if (status == 'Pending')
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          updateRentalStatus(
                                            originalIndex,
                                            'Approved',
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              9,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Approve',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: SizedBox(
                                      height: 36,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          updateRentalStatus(
                                            originalIndex,
                                            'Rejected',
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              9,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Reject',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            else
                              Text(
                                'Status: $status',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: status == 'Approved'
                                      ? Colors.green
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
}
