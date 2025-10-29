import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'router.dart';

class TrendUpApp extends StatelessWidget {
  const TrendUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'TrendUp',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
