import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to notification settings screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: const NotificationList(),
    );
  }
}

class NotificationList extends StatefulWidget {
  const NotificationList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  List<NotificationItem> notifications = [
    NotificationItem(title: 'New Message', body: 'You have received a new message.', isRead: false),
    NotificationItem(title: 'Update Available', body: 'A new update is available for download.', isRead: true),
    // Add more notifications here
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshNotifications,
      child: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return ListTile(
            title: Text(notification.title),
            subtitle: Text(notification.body),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(notification.isRead ? Icons.mark_email_read : Icons.mark_email_unread),
                  onPressed: () {
                    setState(() {
                      notification.isRead = !notification.isRead;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      notifications.removeAt(index);
                    });
                  },
                ),
              ],
            ),
            onTap: () {
              // Navigate to notification details screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationDetailsScreen(notification: notification),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _refreshNotifications() async {
    // Simulate network request to fetch notifications
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      // Update the notification list here
    });
  }
}

class NotificationItem {
  final String title;
  final String body;
  bool isRead;

  NotificationItem({required this.title, required this.body, this.isRead = false});
}

class NotificationDetailsScreen extends StatelessWidget {
  final NotificationItem notification;

  const NotificationDetailsScreen({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(notification.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(notification.body),
      ),
    );
  }
}

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
      ),
      body: const Center(
        child: Text('Settings go here'),
      ),
    );
  }
}
