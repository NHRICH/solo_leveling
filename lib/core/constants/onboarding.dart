import 'package:flutter/material.dart';

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
  });
}

class OnboardingConstants {
  static final List<OnboardingPage> pages = [
    OnboardingPage(
      title: 'I am the Shadow Monarch',
      description:
          'Embrace the power of the King of Shadows and rise above all.',
      icon: Icons.star,
    ),
    OnboardingPage(
      title: 'Awaken Your Gates',
      description:
          'Unleash your inner hunter and awaken the powers within.',
      icon: Icons.star,
    ),
    OnboardingPage(
      title: 'Ruler of the World',
      description:
          'Command the forces of nature and bend destiny to your will.',
      icon: Icons.terrain,
    ),
    OnboardingPage(
      title: 'Step into the Unknown',
      description:
          'Enter a world of monsters, battles, and limitless evolution.',
      icon: Icons.emoji_events,
    ),
  ];
}
