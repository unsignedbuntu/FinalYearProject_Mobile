import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/favorites/favorites_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/splash_screen.dart';
import 'core/constants/app_theme.dart';
import 'widgets/landing_page.dart';
import 'screens/cart/cart_page.dart';
import 'screens/favorites/edit_list_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// Sidebar için placeholder sayfası
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Geri Dön'),
            ),
          ],
        ),
      ),
    );
  }
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
        '/favorites': (context) => const FavoritesPage(),
        '/favorites/edit': (context) => const EditListPage(),

        '/discount-coupons':
            (context) => const PlaceholderPage(title: 'My Discount Coupons'),
        '/my-followed-stores':
            (context) => const PlaceholderPage(title: 'My Followed Stores'),
        '/user-info':
            (context) => const PlaceholderPage(title: 'My User Information'),
        '/address-info':
            (context) => const PlaceholderPage(title: 'My Address Information'),
        '/payment': (context) => const PlaceholderPage(title: 'Payment'),
      },
    );
  }
}
