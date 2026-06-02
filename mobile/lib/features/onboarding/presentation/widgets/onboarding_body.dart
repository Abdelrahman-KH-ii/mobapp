import 'package:farmtec/core/services/preferences_service.dart';
import 'package:farmtec/core/themes/pallete.dart';
import 'package:farmtec/core/widgets/custom_button.dart';
import 'package:farmtec/core/widgets/farm_logo.dart';
import 'package:farmtec/features/auth/presentation/screens/login_screen.dart';
import 'package:farmtec/features/onboarding/data/onboarding_data.dart';
import 'package:farmtec/features/onboarding/presentation/widgets/onboarding_page_dots.dart';
import 'package:farmtec/features/onboarding/presentation/widgets/onboarding_page_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingBody extends StatefulWidget {
  const OnboardingBody({super.key});

  @override
  State<OnboardingBody> createState() => _OnboardingBodyState();
}

class _OnboardingBodyState extends State<OnboardingBody> {
  late PageController _pageController;
  int _currentPage = 0;

  static final int _totalPages = OnboardingData.pages.length;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (page != _currentPage) {
        setState(() => _currentPage = page);
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _onGetStarted();
    }
  }

  void _onGetStarted() async {
    await PreferencesService.setOnboardingSeen();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  void _skip() {
    _pageController.animateToPage(
      _totalPages - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _totalPages - 1;

    return SafeArea(
      child: Column(
        children: [
          // ── Top app bar ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // FarmTech logo
                FarmLogo(),
                // Skip button (hidden on last page)
                AnimatedOpacity(
                  opacity: isLast ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: GestureDetector(
                    onTap: _skip,
                    child: Text(
                      'SKIP',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Pallete.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Page content ──
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
              child: OnboardingPageView(pageController: _pageController),
            ),
          ),

          // ── Bottom section: dots + buttons ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              children: [
                // Page indicator dots
                OnboardingPageDots(
                  currentPage: _currentPage,
                  total: _totalPages,
                ),
                const SizedBox(height: 24),

                // Next / Get Started button
                CustomButton(
                  text: isLast ? 'Get Started' : 'Next',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: _nextPage,
                ),
                const SizedBox(height: 16),

                // Skip onboarding text link (hidden on last page)
                AnimatedOpacity(
                  opacity: isLast ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 250),
                  child: GestureDetector(
                    onTap: _skip,
                    child: Text(
                      'SKIP ONBOARDING',
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: const Color(0xFF9CA3AF),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

