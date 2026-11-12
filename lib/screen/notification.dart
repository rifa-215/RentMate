import 'package:flutter/material.dart';

import 'notification_data.dart';

class NotificationScreen extends StatefulWidget {
  final String recipient;

  const NotificationScreen({super.key, this.recipient = 'renter'});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  static const Color orange = Color(0xFFFF8A00);
  static const Color black = Color(0xFF171717);

  void markAllAsRead() {
    setState(() {
      NotificationData.markAllAsRead(widget.recipient);
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifications = NotificationData.getFor(widget.recipient);

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
          'Notifications',
          style: TextStyle(
            color: black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: markAllAsRead,
              child: const Text(
                'Read All',
                style: TextStyle(
                  color: orange,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(width: 10),
        ],
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF3E8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      size: 55,
                      color: orange,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Notifications Yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'We will notify you when something happens.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: notification['isRead'] == true
                        ? Colors.white
                        : const Color(0xFFFFF3E8),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Color(0xFFFFE3C2),
                        child: Icon(
                          Icons.notifications_active_outlined,
                          color: orange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              notification['title'].toString(),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: black,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              notification['message'].toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              notification['time'].toString(),
                              style: const TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (notification['isRead'] != true)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: orange,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
