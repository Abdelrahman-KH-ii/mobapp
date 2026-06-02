import 'package:farmtec/features/home/presentation/widgets/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavButton extends StatelessWidget {
  final NavItem item;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const NavButton({
    super.key,
    required this.item,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              width: isActive ? 42 : 36,
              height: isActive ? 30 : 28,
              decoration: BoxDecoration(
                color: isActive ? Colors.white.withAlpha(25) : Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                isActive ? item.activeIcon : item.icon,
                size: isActive ? 22 : 20,
                color: isActive ? Colors.white : Colors.white.withAlpha(120),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: isActive ? 9 : 8,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Colors.white : Colors.white.withAlpha(120),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
