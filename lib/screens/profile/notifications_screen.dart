import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../utils/travel_images.dart';
import '../../utils/app_theme.dart';
import '../../utils/app_design_system.dart';
import '../../widgets/image_first_card.dart';
import '../../l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.notifications),
      ),
      body: TravelImages.buildImageBackground(
        imageUrl: TravelImages.getNotificationBackground(0),
        opacity: 0.1,
        cacheWidth: 600,
        child: ListView.builder(
          padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            final read = notification['read'] as bool;
            return ImageFirstCard(
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(AppDesignSystem.spacingLg),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: read
                            ? AppTheme.textSecondary.withOpacity(0.15)
                            : AppTheme.primaryColor.withOpacity(0.15),
                        borderRadius: AppDesignSystem.borderRadiusSm,
                      ),
                      child: Icon(
                        Icons.notifications,
                        color: read
                            ? AppTheme.textSecondary
                            : AppTheme.primaryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppDesignSystem.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            notification['title'] as String,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            notification['message'] as String,
                            style: TextStyle(
                              fontSize: 14,
                              color: AppTheme.textSecondary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            DateFormat('MMM dd, yyyy HH:mm')
                                .format(notification['time'] as DateTime),
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!read)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}



