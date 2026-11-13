import 'notification_data.dart';

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
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String customerAddress,
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
      'hasReviewed': false,
      'rating': null,
      'review': '',
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
    });

    NotificationData.addNotification(
      title: 'New Rental Request',
      message:
          'You have received a new rental request for ${product['name']}. Please check your rental requests.',
      recipient: 'owner',
    );

    NotificationData.addNotification(
      title: 'Rental Request Sent',
      message:
          'Your rental request for ${product['name']} has been sent successfully.',
      recipient: 'renter',
    );
  }

  static void updateStatus(int index, String newStatus) {
    if (index >= 0 && index < rentals.length) {
      final rental = rentals[index];

      if (rental['status'] == newStatus) return;

      rental['status'] = newStatus;

      final productName = rental['product']['name'];

      if (newStatus == 'Approved') {
        NotificationData.addNotification(
          title: 'Rental Request Approved',
          message: 'Your rental request for $productName has been approved!',
          recipient: 'renter',
        );
      } else if (newStatus == 'Rejected') {
        NotificationData.addNotification(
          title: 'Rental Request Rejected',
          message:
              'Sorry, your rental request for $productName has been rejected.',
          recipient: 'renter',
        );
      }
    }
  }

  static void saveReview({
    required int index,
    required int rating,
    required String comment,
  }) {
    if (index >= 0 && index < rentals.length) {
      rentals[index]['rating'] = rating;
      rentals[index]['review'] = comment;
      rentals[index]['hasReviewed'] = true;
    }
  }
}
