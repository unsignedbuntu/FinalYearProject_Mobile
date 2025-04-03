import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/screens/address/address.dart';
import 'package:project/screens/address/empty_address.dart';
import 'package:project/screens/coupons/discount_coupons_page.dart';
import 'package:project/screens/favorites/favorites_page.dart';
import 'package:project/screens/my_reviews/my_reviews_page.dart';
import 'package:project/screens/user_info/user_info_page.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/splash_screen.dart';
import 'core/constants/app_theme.dart';
import 'widgets/landing_page.dart';
import 'screens/cart/cart_page.dart';
import 'screens/favorites/edit_list_page.dart';
import 'package:project/screens/auth/sign_in_page.dart';
import 'package:project/screens/auth/sign_up_page.dart';
import 'package:project/pages/support_page.dart';
import 'package:project/screens/orders/my_orders_page.dart';
import 'package:project/screens/payment/payment_page.dart';

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
        CartPage.routeName: (context) => const CartPage(),
        '/profile': (context) => const ProfilePage(),
        FavoritesPage.routeName: (context) => const FavoritesPage(),
        EditListPage.routeName: (context) => const EditListPage(),
        AddAddressPage.routeName: (context) => const AddAddressPage(),
        EmptyAddressPage.routeName: (context) => const EmptyAddressPage(),
        MyReviewsPage.routeName: (context) => const MyReviewsPage(),
        DiscountCouponsPage.routeName: (context) => const DiscountCouponsPage(),
        '/my-followed-stores':
            (context) => const PlaceholderPage(title: 'My Followed Stores'),
        UserInfoPage.routeName: (context) => const UserInfoPage(),
        '/payment': (context) => const PlaceholderPage(title: 'Payment'),
        SignInPage.routeName: (context) => const SignInPage(),
        SignUpPage.routeName: (context) => const SignUpPage(),
        SupportPage.routeName: (context) => const SupportPage(),
        MyOrdersPage.routeName: (context) => const MyOrdersPage(),
        PaymentPage.routeName: (context) => const PaymentPage(),
      },
    );
  }
}
