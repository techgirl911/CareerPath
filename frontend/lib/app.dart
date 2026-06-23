import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:careerpath/theme/app_theme.dart';
import 'package:careerpath/routes/app_routes.dart';

class CareerPathApp extends StatelessWidget {
  const CareerPathApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CareerPath',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: AppRoutes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
