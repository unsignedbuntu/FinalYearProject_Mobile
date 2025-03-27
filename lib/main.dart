import 'package:flutter/material.dart';
import 'presentation/pages/splash_screen.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/product_list_page.dart';
import 'presentation/pages/product_detail_page.dart';
import 'presentation/pages/cart_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/pages/register_page.dart';
import 'core/constants/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KTUN E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomePage(),
        '/products': (context) => const ProductListPage(),
        '/product_detail': (context) => const ProductDetailPage(),
        '/cart': (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
      },
    );
  }
}
