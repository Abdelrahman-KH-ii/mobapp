import 'package:farmtec/core/utils/assets.dart';
import 'package:farmtec/features/onboarding/data/onboarding_page_model.dart';

class OnboardingData {
  static const List<OnboardingPageModel> pages = [
    OnboardingPageModel(
      image: Assets.onboardingFirst,
      title: 'Maximize Your Profits',
      subtitle:
          'Real-time market tracking and AI-driven price forecasting to help you sell at the optimal moment.',
      topCard: OnboardingCardData(
        emoji: '📈',
        label: 'VEGETATION INDEX',
        value: '0.82 NDVI',
        subtitle: '+4% vs last scan',
      ),
      bottomCard: OnboardingCardData(
        emoji: '☀️',
        label: 'LIGHT EXPOSURE',
        value: '94%',
      ),
    ),
    OnboardingPageModel(
      image: Assets.onboardingSecond,
      title: 'AI-Powered\nInsights',
      subtitle:
          'Upload photos of your crops for instant disease detection and nutrient analysis.',
      topCard: OnboardingCardData(
        emoji: '📊',
        label: 'STATUS',
        value: 'Analysis in Progress...',
      ),
      bottomCard: OnboardingCardData(
        emoji: '🌿',
        label: 'DETECTION',
        value: '98.4% Confidence',
      ),
    ),
    OnboardingPageModel(
      image: Assets.onboardingThird,
      title: 'Optimize\nEvery Drop',
      subtitle:
          'Automated irrigation plans that adjust based on weather forecasts and soil moisture levels.',
      tagLabel: 'SMART IRRIGATION',
      topCard: OnboardingCardData(emoji: '💧', label: 'MOISTURE', value: '68%'),
      bottomCard: OnboardingCardData(
        emoji: '☁️',
        label: 'FORECAST',
        value: 'Rain 2pm',
      ),
      featureItem: OnboardingFeature(
        emoji: '🤖',
        title: 'Predictive Scaling',
        description: 'Systems scale water use 12 hours before rain events.',
      ),
    ),
  ];
}
