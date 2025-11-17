import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'router.dart';

class trendupApp extends StatelessWidget {
  const trendupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'trendup',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
