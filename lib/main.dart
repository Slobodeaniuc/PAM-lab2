import 'package:flutter/material.dart';

import 'screens/course_overview_screen.dart';
import 'screens/home_screen.dart';

// Punctul de intrare in aplicatie
void main() {
  runApp(const OnlineCourseApp());
}

/// Configurarea generala a aplicatiei (tema, fontul, ecranul de start).
class OnlineCourseApp extends StatelessWidget {
  const OnlineCourseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Course App',
      theme: ThemeData(
        useMaterial3: true,
        // Fontul din design-ul Figma
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3D5CFF)),
      ),
      // Cele doua ecrane ale aplicatiei
      initialRoute: HomeScreen.route,
      routes: {
        HomeScreen.route: (_) => const HomeScreen(),
        CourseOverviewScreen.route: (_) => const CourseOverviewScreen(),
      },
    );
  }
}
