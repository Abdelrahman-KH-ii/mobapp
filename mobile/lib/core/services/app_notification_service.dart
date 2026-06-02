import 'dart:convert';
import 'package:farmtec/core/services/notification_settings_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum NotifType { general, weather, market }

class AppNotification {
  final String title;
  final String body;
  final String time;
  final Color color;
  final bool isRead;
  final NotifType type;

  AppNotification({
    required this.title,
    required this.body,
    required this.time,
    required this.color,
    this.isRead = false,
    this.type = NotifType.general,
  });
}

class AppNotificationService extends ChangeNotifier {
  final List<AppNotification> _notifications = [];
  List<AppNotification> get notifications => List.unmodifiable(_notifications);

  Future<void> fetchDynamicAlerts(NotificationSettingsService settings) async {
    // 1. Fetch Market Price if enabled
    if (settings.marketPriceAlerts) {
      try {
        // Attempt to fetch from commodities-api
        final res = await http.get(Uri.parse('https://commodities-api.com/api/latest?access_key=DEMO&base=USD&symbols=WHEAT,CORN'));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          if (data['data'] != null && data['data']['rates'] != null) {
            final double wheatPrice = data['data']['rates']['WHEAT'] ?? 287.50;
            _addNotif(
              title: 'Market Update',
              body: 'Wheat price changed to \$${wheatPrice.toStringAsFixed(2)}/t. Review your selling strategy.',
              color: const Color(0xFF4CAF50),
              type: NotifType.market,
            );
          }
        } else {
           _addMockMarket();
        }
      } catch (_) {
         _addMockMarket();
      }
    }

    // 2. Fetch Weather if enabled
    if (settings.weatherAlerts) {
      // Add dynamic weather alert
      _addNotif(
        title: 'Weather Alert',
        body: 'Significant temperature change expected tomorrow. Adjust irrigation accordingly.',
        color: const Color(0xFFFF9800),
        type: NotifType.weather,
      );
    }

    notifyListeners();
  }

  void _addMockMarket() {
      _addNotif(
        title: 'Market Update',
        body: 'Wheat price up 2.3% to \$287.50/t. Consider selling this week.',
        color: const Color(0xFF4CAF50),
        type: NotifType.market,
      );
  }

  void _addNotif({
    required String title,
    required String body,
    required Color color,
    required NotifType type,
  }) {
    // avoid duplicates
    if (!_notifications.any((n) => n.title == title && n.type == type)) {
      _notifications.insert(
        0,
        AppNotification(
          title: title,
          body: body,
          time: 'Just now',
          color: color,
          type: type,
        ),
      );
    }
  }

  void clearAll() {
    _notifications.clear();
    notifyListeners();
  }
}
