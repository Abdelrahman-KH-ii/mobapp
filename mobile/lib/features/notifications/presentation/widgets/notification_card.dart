import 'package:farmtec/core/services/app_notification_service.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationCard extends StatelessWidget {
  final AppNotification item;

  const NotificationCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: item.isRead ? Colors.white : item.color.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
        border: item.isRead
            ? null
            : Border.all(color: item.color.withAlpha(60), width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: item.color.withAlpha(25),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(_iconFor(item.type), color: item.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Pallete.primaryColor,
                        ),
                      ),
                    ),
                    if (!item.isRead)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: item.color,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  item.body,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.time,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    color: const Color(0xFFBDBDBD),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(NotifType type) {
    switch (type) {
      case NotifType.weather:
        return Icons.wb_cloudy_outlined;
      case NotifType.market:
        return Icons.show_chart_rounded;
      case NotifType.general:
        return Icons.notifications_outlined;
    }
  }
}
