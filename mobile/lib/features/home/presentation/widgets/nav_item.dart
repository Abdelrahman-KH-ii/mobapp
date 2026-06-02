import 'package:flutter/material.dart';

class NavItem {
  final String key;
  final IconData icon;
  final IconData activeIcon;

  const NavItem({
    required this.key,
    required this.icon,
    required this.activeIcon,
  });
}

const navItems = [
  NavItem(
    key: 'dashboard',
    icon: Icons.dashboard_outlined,
    activeIcon: Icons.dashboard_rounded,
  ),
  NavItem(
    key: 'my_farm',
    icon: Icons.grass_outlined,
    activeIcon: Icons.grass_rounded,
  ),
  NavItem(
    key: 'ai_models',
    icon: Icons.auto_awesome_outlined,
    activeIcon: Icons.auto_awesome_rounded,
  ),
  NavItem(
    key: 'market',
    icon: Icons.show_chart_rounded,
    activeIcon: Icons.candlestick_chart_rounded,
  ),
];
