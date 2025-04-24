import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medicationtracker/core/constants/theme_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingSteps = [
  {
    'title': 'Nunca mais esqueça seus medicamentos',
    'description':
        'Acompanhe seus medicamentos e receba lembretes para tomá-los no horário certo.',
    'image': 'assets/onboard/1.png',
  },
  {
    'title': 'Gerencie múltiplos perfis',
    'description':
        'Cuide de seus entes queridos gerenciando seus medicamentos em um único aplicativo.',
    'image': 'assets/onboard/2.png',
  },
  {
    'title': 'Acompanhe o histórico de medicamentos',
    'description':
        'Visualize facilmente o histórico de medicamentos tomados e compartilhe com seu médico.',
    'image': 'assets/onboard/3.png',
  },
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentStep = 0;

  void handleNext() async {
    if (currentStep < onboardingSteps.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_seen', true);
      if (!mounted) return;
      GoRouter.of(context).go('/login');
    }
  }

  void handleSkip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);

    if (context.mounted) GoRouter.of(context).go('/login');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => currentStep = index);
            },
            itemCount: onboardingSteps.length,
            itemBuilder: (context, index) {
              final step = onboardingSteps[index];
              return Stack(
                children: [
                  SizedBox(
                    width: size.width,
                    height: size.height,
                    child: Image.asset(
                      step['image'].toString(),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.black.withOpacity(0.5),
                  ),
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              onboardingSteps.length,
                              (dotIndex) => AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                ),
                                width: dotIndex == currentStep ? 24 : 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color:
                                      dotIndex == currentStep
                                          ? theme.colorScheme.background
                                          : theme.colorScheme.background
                                              .withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            step['title']!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                              fontFamily: AppFontFamily.regular,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            step['description']!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onPrimary.withOpacity(
                                0.7,
                              ),
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: handleSkip,
                                child: Text(
                                  'Pular',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.colorScheme.onPrimary
                                        .withOpacity(0.7),
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 24,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: handleNext,
                                child: Row(
                                  children: [
                                    Text(
                                      currentStep == onboardingSteps.length - 1
                                          ? 'Começar'
                                          : 'Próximo',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme.colorScheme.onPrimary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 15,
                                      color: AppColors.background,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
