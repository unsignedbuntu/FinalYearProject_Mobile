import 'package:flutter/material.dart';
import 'presentation/pages/cart_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/splash_screen.dart';
import 'core/constants/app_theme.dart';
import 'widgets/landing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
