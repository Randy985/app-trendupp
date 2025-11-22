import 'package:flutter/material.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = OnboardingController();
  final pageController = PageController();
  int currentPage = 0;

  final slides = const [
    OnboardingSlide(
      title: "Inspírate con IA",
      description: "Descubre ideas nuevas para tus videos virales.",
      icon: Icons.lightbulb_outline_rounded,
      color: Color(0xFF6A11CB),
    ),
    OnboardingSlide(
      title: "Crea contenido único",
      description: "Te mostramos retos, sonidos y hashtags ideales.",
      icon: Icons.auto_awesome_rounded,
      color: Color(0xFF2575FC),
    ),
    OnboardingSlide(
      title: "Guarda y comparte",
      description: "Organiza tus ideas y vuelve a ellas cuando quieras.",
      icon: Icons.cloud_upload_outlined,
      color: Color(0xFFFF7B54),
    ),
  ];

  Future<void> next() async {
    if (currentPage < slides.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      final navigator = Navigator.of(context);

      await controller.setSeen();
      if (!mounted) return;
      navigator.pushReplacementNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: pageController,
            onPageChanged: (i) => setState(() => currentPage = i),
            itemCount: slides.length,
            itemBuilder: (_, i) => slides[i],
          ),
          Positioned(
            bottom: 80,
            child: Row(
              children: List.generate(
                slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: currentPage == i ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: currentPage == i
                        ? slides[i].color
                        : slides[i].color.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            child: ElevatedButton(
              onPressed: next,
              style: ElevatedButton.styleFrom(
                backgroundColor: slides[currentPage].color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 50,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 3,
              ),
              child: Text(
                currentPage == slides.length - 1 ? "Comenzar" : "Siguiente",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
