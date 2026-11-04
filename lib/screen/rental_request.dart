import 'package:flutter/material.dart';

import 'rental_confirm.dart';
import 'rental_data.dart';

class RentalRequestScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  const RentalRequestScreen({super.key, required this.product});

  @override
  State<RentalRequestScreen> createState() => _RentalRequestScreenState();
}

class _RentalRequestScreenState extends State<RentalRequestScreen> {
  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  DateTime? startDate;
  DateTime? endDate;

  String? deliveryMethod;
  String? paymentMethod;

  int get rentalDays {
    if (startDate == null || endDate == null) return 0;
    return endDate!.difference(startDate!).inDays + 1;
  }

  // Mengubah harga produk menjadi angka.
  int get pricePerDay {
    final rawPrice = widget.product['price'];

    if (rawPrice is num) return rawPrice.toInt();

    return int.tryParse(
          rawPrice.toString().replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        0;
  }

  int get totalPrice => pricePerDay * rentalDays;

  String formatRupiah(int price) {
    final result = price.toString();
    final formatted = result.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]}.',
    );
    return 'Rp$formatted';
  }

  Future<void> selectDate(bool isStartDate) async {
    final today = DateUtils.dateOnly(DateTime.now());

    final firstDate = isStartDate ? today : (startDate ?? today);

    final selectedDate = await showDatePicker(
      context: context,
      initialDate: isStartDate ? (startDate ?? today) : (endDate ?? firstDate),
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (selectedDate == null) return;

    setState(() {
      if (isStartDate) {
        startDate = selectedDate;

        if (endDate != null && endDate!.isBefore(selectedDate)) {
          endDate = null;
        }
      } else {
        endDate = selectedDate;
      }
    });
  }

  String formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final canSubmit =
        startDate != null &&
        endDate != null &&
        deliveryMethod != null &&
        paymentMethod != null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: black),
        ),
        title: const Text(
          'Rental Request',
          style: TextStyle(color: black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product['name'].toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      '${formatRupiah(pricePerDay)}/day',
                      style: const TextStyle(
                        color: orange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      'Rental Period',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),

                    const SizedBox(height: 15),

                    dateTile(
                      title: 'Start Date',
                      date: startDate,
                      onTap: () => selectDate(true),
                    ),

                    const SizedBox(height: 15),

                    dateTile(
                      title: 'End Date',
                      date: endDate,
                      onTap: startDate == null ? null : () => selectDate(false),
                    ),

                    const SizedBox(height: 30),

                    // DELIVERY METHOD
                    const Text(
                      'Delivery Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'How would you like to receive the item?',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),

                    const SizedBox(height: 15),

                    optionTile(
                      title: 'Self Pickup',
                      subtitle: 'Pick up the item directly from the owner.',
                      icon: Icons.store_rounded,
                      value: 'Self Pickup',
                      groupValue: deliveryMethod,
                      onTap: () {
                        setState(() {
                          deliveryMethod = 'Self Pickup';
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    optionTile(
                      title: 'Delivery',
                      subtitle: 'The owner delivers the item to you.',
                      icon: Icons.local_shipping_rounded,
                      value: 'Delivery',
                      groupValue: deliveryMethod,
                      onTap: () {
                        setState(() {
                          deliveryMethod = 'Delivery';
                        });
                      },
                    ),

                    const SizedBox(height: 30),

                    // PAYMENT METHOD
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'Choose your preferred payment method.',
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),

                    const SizedBox(height: 15),

                    optionTile(
                      title: 'E-Wallet',
                      subtitle: 'Simulated e-wallet payment.',
                      icon: Icons.account_balance_wallet_rounded,
                      value: 'E-Wallet',
                      groupValue: paymentMethod,
                      onTap: () {
                        setState(() {
                          paymentMethod = 'E-Wallet';
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    optionTile(
                      title: 'Bank Transfer',
                      subtitle: 'Simulated bank transfer payment.',
                      icon: Icons.account_balance_rounded,
                      value: 'Bank Transfer',
                      groupValue: paymentMethod,
                      onTap: () {
                        setState(() {
                          paymentMethod = 'Bank Transfer';
                        });
                      },
                    ),

                    const SizedBox(height: 12),

                    optionTile(
                      title: 'Cash',
                      subtitle: 'Pay in cash as agreed with the owner.',
                      icon: Icons.payments_rounded,
                      value: 'Cash',
                      groupValue: paymentMethod,
                      onTap: () {
                        setState(() {
                          paymentMethod = 'Cash';
                        });
                      },
                    ),

                    const SizedBox(height: 30),

                    const Divider(),

                    const SizedBox(height: 15),

                    // ORDER SUMMARY
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: black,
                      ),
                    ),

                    const SizedBox(height: 15),

                    summaryRow('Rental Duration', '$rentalDays day(s)'),

                    const SizedBox(height: 12),

                    summaryRow('Price per Day', formatRupiah(pricePerDay)),

                    const SizedBox(height: 12),

                    summaryRow('Delivery Method', deliveryMethod ?? '-'),

                    const SizedBox(height: 12),

                    summaryRow('Payment Method', paymentMethod ?? '-'),

                    const Divider(height: 30),

                    summaryRow(
                      'Total Payment',
                      formatRupiah(totalPrice),
                      isTotal: true,
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // SUBMIT BUTTON
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: canSubmit
                      ? () {
                          // Simpan data rental
                          RentalData.addRental(
                            product: widget.product,
                            startDate: startDate!,
                            endDate: endDate!,
                            rentalDays: rentalDays,
                            deliveryMethod: deliveryMethod!,
                            paymentMethod: paymentMethod!,
                            totalPrice: totalPrice,
                          );

                          // Buka halaman konfirmasi
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RentalConfirmationScreen(
                                product: widget.product,
                                startDate: startDate!,
                                endDate: endDate!,
                                rentalDays: rentalDays,
                                deliveryMethod: deliveryMethod!,
                                paymentMethod: paymentMethod!,
                                totalPrice: totalPrice,
                              ),
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
                    'Submit Rental Request',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DATE TILE
  Widget dateTile({
    required String title,
    required DateTime? date,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month, color: orange),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    formatDate(date),
                    style: const TextStyle(
                      color: black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // SELECTABLE OPTION TILE
  Widget optionTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required String value,
    required String? groupValue,
    required VoidCallback onTap,
  }) {
    final isSelected = groupValue == value;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFF3E8) : const Color(0xFFF8F8F8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? orange : Colors.grey.shade200,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: orange, size: 25),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: black,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? orange : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  // ORDER SUMMARY ROW
  Widget summaryRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isTotal ? black : Colors.grey,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            fontSize: isTotal ? 16 : 13,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: isTotal ? orange : black,
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 18 : 13,
            ),
          ),
        ),
      ],
    );
  }
}
