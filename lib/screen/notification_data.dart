class NotificationData {
  static final List<Map<String, dynamic>> notifications = [];

  static void addNotification({
    required String title,
    required String message,
    required String recipient,
  }) {
    notifications.insert(0, {
      'title': title,
      'message': message,
      'recipient': recipient,
      'time': 'Just now',
      'isRead': false,
    });
  }

  static List<Map<String, dynamic>> getFor(String recipient) {
    return notifications.where((notification) {
      return notification['recipient'] == recipient;
    }).toList();
  }

  static void markAllAsRead(String recipient) {
    for (var notification in notifications) {
      if (notification['recipient'] == recipient) {
        notification['isRead'] = true;
      }
    }
  }

  static int unreadCountFor(String recipient) {
    return notifications.where((notification) {
      return notification['recipient'] == recipient &&
          notification['isRead'] != true;
    }).length;
  }
}
