class RentalData {
  static final List<Map<String, dynamic>> rentals = [];

  static void addRental({
    required Map<String, dynamic> product,
    required DateTime startDate,
    required DateTime endDate,
    required int rentalDays,
    required String deliveryMethod,
    required String paymentMethod,
    required int totalPrice,
  }) {
    rentals.add({
      'product': product,
      'startDate': startDate,
      'endDate': endDate,
      'rentalDays': rentalDays,
      'deliveryMethod': deliveryMethod,
      'paymentMethod': paymentMethod,
      'totalPrice': totalPrice,
      'status': 'Pending',
    });
  }
}
