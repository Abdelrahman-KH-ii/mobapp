import 'package:flutter/material.dart';

enum SupportInfoPage { helpFaq, privacyPolicy, aboutUs, contact }

class SupportInfoSection {
  final String title;
  final List<String> lines;

  const SupportInfoSection(this.title, this.lines);
}

class SupportInfoData {
  final String title;
  final String heading;
  final String summary;
  final IconData icon;
  final Color color;
  final List<SupportInfoSection> sections;

  const SupportInfoData({
    required this.title,
    required this.heading,
    required this.summary,
    required this.icon,
    required this.color,
    required this.sections,
  });

  factory SupportInfoData.forPage(SupportInfoPage page) {
    switch (page) {
      case SupportInfoPage.helpFaq:
        return const SupportInfoData(
          title: 'Help & FAQ',
          heading: 'How can we help?',
          summary:
              'Quick answers for the whole FarmTec app: dashboard, farms, AI models, NDVI, market data, notifications, profile, and account settings.',
          icon: Icons.help_outline_rounded,
          color: Color(0xFF2196F3),
          sections: [
            SupportInfoSection('Using NDVI', [
              'Open My Farm, select a field, then tap Run Scan to refresh the vegetation index.',
              'Scores near 1.00 indicate strong plant vigor. Lower scores point to water, nutrient, or disease stress.',
            ]),
            SupportInfoSection('Dashboard and profit', [
              'The dashboard summarizes weather, farm status, tasks, market context, and projected gross profit.',
              'Profit uses the latest Yield Prediction model result, then multiplies it by the current market price.',
            ]),
            SupportInfoSection('AI models', [
              'Open AI Models to run crop recommendation, disease detection, yield prediction, irrigation, weather, and nutrient tools.',
              'Yield Prediction saves its latest result so the profit calculator can use the same number.',
            ]),
            SupportInfoSection('Managing fields', [
              'Use Add Field to save a field name, crop, area, and GPS location.',
              'Tap any field card to view crop lifecycle, soil readings, NDVI analysis, activity, and AI insights.',
            ]),
            SupportInfoSection('Crop lifecycle', [
              'Lifecycle cards show stage windows and field actions for every available crop.',
              'Supported crops include Wheat, Maize, Rice, Tomato, Potato, Mango, Jowar (Sorghum), and Green Fodder.',
            ]),
            SupportInfoSection('Market and notifications', [
              'Market shows commodity prices and forecast details for supported crops.',
              'Profile controls push notifications plus weather and market price alert categories.',
            ]),
            SupportInfoSection('Alerts and notifications', [
              'Weather and market price alerts can be enabled or disabled from Profile.',
              'Critical field health should be inspected in person before applying treatment.',
            ]),
          ],
        );
      case SupportInfoPage.privacyPolicy:
        return const SupportInfoData(
          title: 'Privacy Policy',
          heading: 'Your farm data stays yours',
          summary:
              'FarmTec uses account, field, and location data only to provide farm monitoring, recommendations, and app functionality.',
          icon: Icons.privacy_tip_outlined,
          color: Color(0xFF7C3AED),
          sections: [
            SupportInfoSection('Data we use', [
              'Profile details, selected farms, crop information, field locations, and app preferences.',
              'Location is used for maps, weather context, field boundaries, and vegetation analysis.',
            ]),
            SupportInfoSection('How data is protected', [
              'Local preferences are stored on the device for faster access.',
              'We do not sell personal or farm data. Shared reports should be sent only to people you trust.',
            ]),
            SupportInfoSection('Your choices', [
              'You can update profile details, change notification settings, or sign out from Profile.',
              'Remove saved farms when you no longer want them available in the app.',
            ]),
          ],
        );
      case SupportInfoPage.aboutUs:
        return const SupportInfoData(
          title: 'About Us',
          heading: 'Precision intelligence for farms',
          summary:
              'FarmTec brings field monitoring, satellite-style vegetation analysis, market context, and AI guidance into one mobile workspace.',
          icon: Icons.info_outline_rounded,
          color: Color(0xFF1B8F3A),
          sections: [
            SupportInfoSection('What we build', [
              'Tools that help growers understand crop health, soil condition, irrigation needs, and market movement.',
              'Simple field workflows that make data useful while work is happening.',
            ]),
            SupportInfoSection('Our approach', [
              'Clear recommendations, practical metrics, and fast access from the farm dashboard.',
              'AI support is designed to assist decisions, not replace field inspection or agronomic judgment.',
            ]),
          ],
        );
      case SupportInfoPage.contact:
        return const SupportInfoData(
          title: 'Contact',
          heading: 'Talk to FarmTec support',
          summary:
              'Reach out for account help, field setup questions, product feedback, or partnership conversations.',
          icon: Icons.contact_support_outlined,
          color: Color(0xFFFF9800),
          sections: [
            SupportInfoSection('Support', [
              'Email: support@farmtec.io',
              'Phone: +20 100 000 0000',
              'Hours: Sunday to Thursday, 9:00 AM - 6:00 PM Cairo time.',
            ]),
            SupportInfoSection('When contacting us', [
              'Include your farm name, field name, crop, and the screen where you saw the issue.',
              'For NDVI or map issues, include the field GPS location if available.',
            ]),
          ],
        );
    }
  }
}
