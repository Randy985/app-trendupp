import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/onboarding/controllers/onboarding_controller.dart';
import 'features/onboarding/pages/onboarding_page.dart';
import 'features/auth/pages/login_page.dart';
import 'features/home/home_page.dart';
import 'features/home/pages/generate_view.dart'; // 🔹 agrega esto

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final user = FirebaseAuth.instance.currentUser;
  final onboarding = OnboardingController();
  final seen = await onboarding.hasSeenOnboarding();

  // Decide ruta inicial
  String initialRoute;
  if (user != null) {
    initialRoute = '/home';
  } else if (!seen) {
    initialRoute = '/';
  } else {
    initialRoute = '/login';
  }

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TrendUp',
      theme: ThemeData(useMaterial3: true),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const OnboardingPage(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/generate': (context) => const GenerateView(), // 🔹 esta línea nueva
      },
    );
  }
}
