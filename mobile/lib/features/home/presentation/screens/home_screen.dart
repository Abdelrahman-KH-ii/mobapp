import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/features/ai_models/presentation/widgets/ai_models_view.dart';
import 'package:farmtec/features/chat/presentation/screens/farmbrain_chat_screen.dart';
import 'package:farmtec/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:farmtec/features/home/presentation/widgets/custom_bottom_nav_bar.dart';
import 'package:farmtec/features/market/presentation/widgets/market_view.dart';
import 'package:farmtec/features/my_farm/presentation/widgets/my_farm_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const List<Widget> _pages = [
    DashboardScreen(),
    MyFarmView(),
    AIModelsView(),
    MarketView(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Pallete.darkBackground : Pallete.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: KeyedSubtree(
                  key: ValueKey(_currentIndex),
                  child: _pages[_currentIndex],
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CustomBottomNavBar(
                currentIndex: _currentIndex,
                onIndexChanged: (index) =>
                    setState(() => _currentIndex = index),
                onChatPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) =>
                          const FarmBrainChatScreen(),
                      transitionsBuilder: (_, anim, __, child) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(
                            CurvedAnimation(
                              parent: anim,
                              curve: Curves.easeOutCubic,
                            ),
                          ),
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
