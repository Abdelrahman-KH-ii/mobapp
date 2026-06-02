import 'package:farmtec/core/themes/pallete.dart';
import 'package:flutter/material.dart';

class DashboardIconButton extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final bool hasBadge;
  final VoidCallback onTap;

  const DashboardIconButton({
    super.key,
    required this.icon,
    required this.isDark,
    this.hasBadge = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: isDark ? Pallete.darkCard : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(12),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: isDark ? Pallete.darkTextPrimary : Pallete.primary,
              size: 20,
            ),
            if (hasBadge)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF44336),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
