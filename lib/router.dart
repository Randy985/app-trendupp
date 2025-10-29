import 'package:go_router/go_router.dart';
import 'package:trendup_app/features/auth/pages/email_login_page.dart';
import 'features/onboarding/pages/onboarding_page.dart';
import 'features/auth/pages/login_page.dart';
import 'features/home/home_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const OnboardingPage()),
    GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
    GoRoute(path: '/home', builder: (_, __) => const HomePage()),
    GoRoute(path: '/email-login', builder: (_, __) => const EmailLoginPage()),
  ],
);
