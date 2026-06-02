import 'package:farmtec/core/l10n/app_localizations.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/home/presentation/widgets/nav_button.dart';
import 'package:farmtec/features/home/presentation/widgets/nav_item.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onIndexChanged,
    this.onChatPressed,
  });

  final int currentIndex;
  final ValueChanged<int> onIndexChanged;
  final VoidCallback? onChatPressed;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l = AppLocalizations.of(context);
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final barBg = isDark ? Pallete.darkSurface : const Color(0xFF1B4332);

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomPad + 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: barBg,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: barBg.withAlpha(80),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(navItems.length, (i) {
                  return NavButton(
                    item: navItems[i],
                    label: l.tr(navItems[i].key),
                    isActive: i == currentIndex,
                    onTap: () => onIndexChanged(i),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: onChatPressed,
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Pallete.primary, Color(0xFF2D6A4F)],
                ),
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Pallete.primary.withAlpha(80),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
