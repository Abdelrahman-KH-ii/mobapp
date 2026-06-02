import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/features/ai_models/presentation/screens/ai_model_run_screen.dart';
import 'package:farmtec/features/ai_models/presentation/widgets/ai_model_definition.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AiModelTile extends StatelessWidget {
  final AIModelDefinition model;
  final bool isDark;
  final Color cardColor;
  final Color textColor;
  final Color subColor;

  const AiModelTile({
    super.key,
    required this.model,
    required this.isDark,
    required this.cardColor,
    required this.textColor,
    required this.subColor,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AiModelRunScreen(model: model)),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isDark ? 25 : 10),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: model.color.withAlpha(25),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(model.icon, color: model.color, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l.tr(model.name.toLowerCase().replaceAll(' ', '_')),
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    l.tr('${model.name.toLowerCase().replaceAll(' ', '_')}_desc'),
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      color: subColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.api_rounded, size: 12, color: subColor),
                      const SizedBox(width: 4),
                      Text(
                        model.fields.isEmpty
                            ? (l.isArabic ? 'طلب GET' : 'GET request')
                            : (l.isArabic
                                ? '${model.fields.length} معلمات'
                                : '${model.fields.length} parameters'),
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: subColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: model.color.withAlpha(20),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.play_arrow_rounded, color: model.color, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}
