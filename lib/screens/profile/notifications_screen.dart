import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notifications = [
      {
        'title': 'Booking Confirmed',
        'message': 'Your hotel booking has been confirmed',
        'time': DateTime.now().subtract(const Duration(hours: 2)),
        'read': false,
      },
      {
        'title': 'New Tour Available',
        'message': 'Check out our new European Grand Tour',
        'time': DateTime.now().subtract(const Duration(days: 1)),
        'read': false,
      },
      {
        'title': 'Payment Received',
        'message': 'Your payment of \$2999 has been received',
        'time': DateTime.now().subtract(const Duration(days: 2)),
        'read': true,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            color: notification['read'] as bool
                ? Colors.white
                : Colors.blue.shade50,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: const Icon(Icons.notifications, color: Colors.blue),
              ),
              title: Text(
                notification['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(notification['message'] as String),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM dd, yyyy HH:mm')
                        .format(notification['time'] as DateTime),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}



