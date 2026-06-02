import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/services/farm_history_service.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/my_farm_card_style.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FarmActivityTile extends StatelessWidget {
  final FarmOperation op;
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subColor;

  const FarmActivityTile({
    super.key,
    required this.op,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
  });

  String _timeAgo(DateTime dt, AppLocalizations l) {
    final d = DateTime.now().difference(dt);
    if (d.inMinutes < 60) {
      return l.convertNumbers(
        l.trParams('time_ago_minutes', {'n': d.inMinutes.toString()}),
      );
    }
    if (d.inHours < 24) {
      return l.convertNumbers(
        l.trParams('time_ago_hours', {'h': d.inHours.toString()}),
      );
    }
    return l.convertNumbers(
      l.trParams('time_ago_days', {'d': d.inDays.toString()}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: myFarmCardDecoration(isDark, cardColor),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: op.color.withAlpha(25),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(op.icon, color: op.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  op.displayTitle(l),
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                Text(
                  op.description,
                  style: GoogleFonts.manrope(fontSize: 11, color: subColor),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            _timeAgo(op.timestamp, l),
            style: GoogleFonts.manrope(fontSize: 10, color: subColor),
          ),
        ],
      ),
    );
  }
}
