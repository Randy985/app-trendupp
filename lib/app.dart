import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'router.dart';

class TrendupApp extends StatelessWidget {
  const TrendupApp({super.key});

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
