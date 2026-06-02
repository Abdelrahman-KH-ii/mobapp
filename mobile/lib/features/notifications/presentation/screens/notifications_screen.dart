import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/services/app_notification_service.dart';
import 'package:farmtec/core/services/notification_settings_service.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/notifications/presentation/widgets/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  static const routeName = 'notifications';

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifService =
          Provider.of<AppNotificationService>(context, listen: false);
      final settings =
          Provider.of<NotificationSettingsService>(context, listen: false);
      notifService.fetchDynamicAlerts(settings);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifService = Provider.of<AppNotificationService>(context);
    final settings = Provider.of<NotificationSettingsService>(context);
    final items = notifService.notifications;
    final bgColor = isDark ? Pallete.darkBackground : Pallete.background;
    final textColor = isDark ? Pallete.darkTextPrimary : Pallete.primary;
    final subColor = isDark ? Pallete.darkTextSecondary : Pallete.textSecondary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? Pallete.darkCard : Pallete.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          l.tr('notifications'),
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<AppNotificationService>(context, listen: false)
                  .clearAll();
            },
            child: Text(
              l.tr('clear_all'),
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: subColor,
              ),
            ),
          ),
        ],
      ),
      body: items.isEmpty
          ? Center(
              child: Text(
                settings.pushEnabled
                    ? l.tr('no_notifications_match')
                    : l.tr('notifications_off'),
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: subColor,
                ),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              itemCount: items.length,
              itemBuilder: (_, i) => NotificationCard(item: items[i]),
            ),
    );
  }
}
