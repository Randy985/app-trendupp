import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/home_controller.dart';
import 'pages/home_view.dart';
import 'pages/saved_view.dart';
import 'pages/profile_view.dart';
import 'widgets/bottom_nav_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeController>(
      create: (_) => HomeController(),
      child: Consumer<HomeController>(
        builder: (context, controller, _) {
          final pages = [
            const HomeView(),
            const SavedView(),
            const ProfileView(),
          ];

          return Scaffold(
            extendBody: true,
            body: pages[controller.currentIndex],
            bottomNavigationBar: CustomBottomNav(
              currentIndex: controller.currentIndex,
              onTap: controller.setIndex,
            ),
          );
        },
      ),
    );
  }
}
