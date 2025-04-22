import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingSteps = [
  {
    'title': 'Nunca mais esqueça seus medicamentos',
    'description':
        'Acompanhe seus medicamentos e receba lembretes para tomá-los no horário certo.',
    'image':
        'https://images.pexels.com/photos/8942991/pexels-photo-8942991.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  },
  {
    'title': 'Gerencie múltiplos perfis',
    'description':
        'Cuide de seus entes queridos gerenciando seus medicamentos em um único aplicativo.',
    'image':
        'https://images.pexels.com/photos/7551605/pexels-photo-7551605.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
  },
  {
    'title': 'Acompanhe o histórico de medicamentos',
    'description':
        'Visualize facilmente o histórico de medicamentos tomados e compartilhe com seu médico.',
    'image':
        'https://images.pexels.com/photos/7579831/pexels-photo-7579831.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
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
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  void handleSkip() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
                    child: Image.network(step['image']!, fit: BoxFit.cover),
                  ),
                  Container(
                    width: size.width,
                    height: size.height,
                    color: Colors.black.withOpacity(0.4),
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
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.4),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Text(
                            step['title']!,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            step['description']!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: handleSkip,
                                child: const Text(
                                  'Pular',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple,
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
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_ios,
                                      size: 18,
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
