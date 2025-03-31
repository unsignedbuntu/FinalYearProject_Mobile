import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/pages/cart_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/splash_screen.dart';
import 'core/constants/app_theme.dart';
import 'widgets/landing_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KTUN E-Commerce',
      theme: AppTheme.lightTheme,
      // initialRoute: '/splash',
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/cart': (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
      },
    );
  }
}
