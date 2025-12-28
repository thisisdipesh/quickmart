import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/notification_tile.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Sample notification data
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Your order is on the way',
      'message': 'Arriving at 9:05 PM',
      'image': 'https://via.placeholder.com/60',
      'time': '9:05 PM',
      'dateCategory': 'Today',
    },
    {
      'title': 'Order delivered successfully',
      'message': 'Thank you for shopping with us',
      'image': 'https://via.placeholder.com/60',
      'time': '2:30 PM',
      'dateCategory': 'Today',
    },
    {
      'title': 'Special offer on groceries',
      'message': 'Get 20% off on all pantry essentials',
      'image': 'https://via.placeholder.com/60',
      'time': '10:15 AM',
      'dateCategory': 'Today',
    },
    {
      'title': 'Order #1234 confirmed',
      'message': 'Your order will be processed soon',
      'image': 'https://via.placeholder.com/60',
      'time': '8:45 PM',
      'dateCategory': 'Yesterday',
    },
    {
      'title': 'New product available',
      'message': 'Check out our latest arrivals',
      'image': 'https://via.placeholder.com/60',
      'time': '6:20 PM',
      'dateCategory': 'Yesterday',
    },
    {
      'title': 'Payment received',
      'message': 'Your payment of Rs 2,500 has been received',
      'image': 'https://via.placeholder.com/60',
      'time': '4:10 PM',
      'dateCategory': 'Yesterday',
    },
  ];

  List<Map<String, dynamic>> get _todayNotifications {
    return _notifications
        .where((notification) => notification['dateCategory'] == 'Today')
        .toList();
  }

  List<Map<String, dynamic>> get _yesterdayNotifications {
    return _notifications
        .where((notification) => notification['dateCategory'] == 'Yesterday')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Notifications',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView(
              children: [
                // Today Section
                if (_todayNotifications.isNotEmpty) ...[
                  _buildSectionHeader('Today'),
                  ..._todayNotifications.map((notification) {
                    return NotificationTile(
                      title: notification['title'] as String,
                      message: notification['message'] as String,
                      image: notification['image'] as String,
                      time: notification['time'] as String,
                    );
                  }).toList(),
                ],

                // Yesterday Section
                if (_yesterdayNotifications.isNotEmpty) ...[
                  _buildSectionHeader('Yesterday'),
                  ..._yesterdayNotifications.map((notification) {
                    return NotificationTile(
                      title: notification['title'] as String,
                      message: notification['message'] as String,
                      image: notification['image'] as String,
                      time: notification['time'] as String,
                    );
                  }).toList(),
                ],
              ],
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Colors.grey.shade50,
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

