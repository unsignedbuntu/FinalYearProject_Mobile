import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Riverpod importu
import 'package:go_router/go_router.dart'; // GoRouter importu
import 'dart:async'; // For Future, Timer
import 'dart:convert'; // Base64 için
import 'package:collection/collection.dart'; // For firstWhereOrNull

// Models
import 'package:project/data/models/product_model.dart';
import 'package:project/data/models/product_supplier_model.dart';
import 'package:project/data/models/store_model.dart';
import 'package:project/data/models/category_model.dart';
import 'package:project/data/models/supplier_model.dart';

// Specific Services
import 'package:project/services/product_service.dart';
import 'package:project/services/productsupplier_service.dart';
import 'package:project/services/store_service.dart';
import 'package:project/services/supplier_service.dart';
import 'package:project/services/category_service.dart';
import 'package:project/services/image_cache_service.dart';

// --- Sayfa Importları (GoRouter içinde kullanılacaklar) ---
import 'presentation/pages/home_page.dart';
import 'presentation/pages/profile_page.dart';
import 'presentation/pages/splash_screen.dart';
import 'widgets/landing_page.dart';
import 'screens/cart/cart_page.dart';
import 'screens/favorites/edit_list_page.dart';
import 'screens/favorites/favorites_page.dart';
import 'screens/address/address.dart';
import 'screens/address/empty_address.dart';
import 'screens/coupons/discount_coupons_page.dart';
import 'screens/my_reviews/my_reviews_page.dart';
import 'screens/user_info/user_info_page.dart';
import 'screens/auth/sign_in_page.dart';
import 'screens/auth/sign_up_page.dart';
import 'pages/support_page.dart';
import 'screens/orders/my_orders_page.dart';
import 'screens/payment/payment_page.dart';
import 'screens/product/product_details_page.dart';

// --- Diğer Gerekli Importlar ---
import 'core/constants/app_theme.dart';
// Icons
import 'package:project/components/icons/cart_favorites.dart';
import 'package:project/components/icons/favorite_icon.dart';

// Messages
import 'package:project/components/messages/cart_success_message.dart';

// Constants veya veri kaynakları
final Map<String, dynamic> productDetails = {
  // ... (statik veri) ...
};

// İşlenmiş görsel önbelleklerini saklamak için global değişken
final Map<String, String> globalImageCache = {};

// --- ADIM 1: Router Tanımı ---
// Global veya main() altına yerleştirilebilir
final GoRouter _router = GoRouter(
  // initialLocation: '/', // Opsiyonel: Başlangıç rotası (varsayılan '/')

  // --- Tüm Rotaların Tanımlandığı Liste ---
  routes: <RouteBase>[
    // --- Ana Rota ---
    GoRoute(
      path: '/', // Kök dizin
      builder:
          (context, state) =>
              const LandingPage(), // Uygulama LandingPage ile başlıyor
    ),

    // --- Diğer Üst Seviye Rotalar ---
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    // Dinamik Ürün Detay Rotası
    GoRoute(
      path: '/product/:id', // Üst seviye dinamik rota
      builder: (BuildContext context, GoRouterState state) {
        // Path'den 'id' parametresini al
        final String productId =
            state.pathParameters['id'] ?? '0'; // Null kontrolü
        if (productId == '0') {
          // ID alınamazsa loglama ve hata sayfası
          print("Error: Product ID not found or invalid in route parameters.");
          return Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Error: Invalid Product ID')),
          );
        }
        // ID'yi ProductDetailsPage'e gönder
        return ProductDetailsPage(productId: productId);
      },
    ),
    GoRoute(
      path: CartPage.routeName, // '/cart' gibi olmalı
      builder: (context, state) => const CartPage(),
    ),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    GoRoute(
      path: FavoritesPage.routeName, // '/favorites' gibi olmalı
      builder: (context, state) => const FavoritesPage(),
    ),
    GoRoute(
      path: EditListPage.routeName, // '/edit-list' gibi olmalı
      builder: (context, state) => const EditListPage(),
    ),
    GoRoute(
      path: AddAddressPage.routeName, // '/add-address' gibi olmalı
      builder: (context, state) => const AddAddressPage(),
    ),
    // --- YENİ: Yeni Adres Ekleme Rotası ---
    GoRoute(
      path: '/address/new',
      builder:
          (context, state) =>
              const AddAddressPage(), // AddAddressPage'e yönlendir
    ),
    GoRoute(
      path: EmptyAddressPage.routeName, // '/empty-address' gibi olmalı
      builder: (context, state) => const EmptyAddressPage(),
    ),
    GoRoute(
      path: MyReviewsPage.routeName, // '/my-reviews' gibi olmalı
      builder: (context, state) => const MyReviewsPage(),
    ),
    GoRoute(
      path: DiscountCouponsPage.routeName, // '/discount-coupons' gibi olmalı
      builder: (context, state) => const DiscountCouponsPage(),
    ),
    GoRoute(
      path: '/my-followed-stores', // Doğrudan path
      builder:
          (context, state) =>
              const PlaceholderPage(title: 'My Followed Stores'),
    ),
    GoRoute(
      path: UserInfoPage.routeName, // '/user-info' gibi olmalı
      builder: (context, state) => const UserInfoPage(),
    ),
    GoRoute(
      path: SignInPage.routeName, // '/signin' gibi olmalı
      builder: (context, state) => const SignInPage(),
    ),
    GoRoute(
      path: SignUpPage.routeName, // '/signup' gibi olmalı
      builder: (context, state) => const SignUpPage(),
    ),
    GoRoute(
      path: SupportPage.routeName, // '/support' gibi olmalı
      builder: (context, state) => const SupportPage(),
    ),
    GoRoute(
      path: MyOrdersPage.routeName, // '/my-orders' gibi olmalı
      builder: (context, state) => const MyOrdersPage(),
    ),
    GoRoute(
      path: PaymentPage.routeName, // '/payment' gibi olmalı
      builder: (context, state) => const PaymentPage(),
    ),
    // --- YENİ: Mağaza Detay Rotası (Dinamik ID ile) ---
    GoRoute(
      path: '/store/details/:id', // Rota path'i
      builder: (context, state) {
        final categoryId = state.pathParameters['id'] ?? '0';
        if (categoryId == '0') {
          // Hata durumu veya varsayılan davranış
          print(
            "Error: Category ID not found in route parameters for store details.",
          );
          return Scaffold(
            appBar: AppBar(title: Text('Error')),
            body: Center(child: Text('Invalid Category ID')),
          );
        }
        // TODO: Gerçek StoreDetailsPage widget'ını oluştur ve categoryId'yi geç
        return PlaceholderPage(title: 'Store Details for Category $categoryId');
      },
    ),
    // --- YENİ: Şifremi Unuttum Rotası ---
    GoRoute(
      path: '/forgot-password',
      builder:
          (context, state) => const PlaceholderPage(
            title: 'Forgot Password',
          ), // TODO: Gerçek sayfayı ekle
    ),
    // --- YENİ: Ürünler Listesi Rotası ---
    GoRoute(
      path: '/products',
      builder:
          (context, state) => const PlaceholderPage(
            title: 'Products List',
          ), // TODO: Gerçek sayfayı ekle
    ),
  ],

  // --- Hata Durumunda Gösterilecek Sayfa ---
  errorBuilder:
      (context, state) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: Could not find the route ${state.uri}'),
              const SizedBox(height: 8),
              Text('Error Details: ${state.error?.message ?? 'Unknown error'}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/'), // Ana sayfaya dön
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
);

// --- main Fonksiyonu ---
void main() {
  // GoRouter'ın düzgün çalışması için WidgetsFlutterBinding.ensureInitialized() gerekebilir (özellikle derin bağlantı vb. için)
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp())); // Riverpod Scope ile sarılı
}

// --- Sidebar için placeholder sayfası (Hala kullanılıyorsa kalabilir) ---
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
              // GoRouter ile geri dönmek için context.pop() daha uygun olabilir
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/'); // Geri gidilemiyorsa ana sayfaya git
                }
              },
              child: const Text('Geri Dön'),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Ana Uygulama Widget'ı ---
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- ADIM 2: MaterialApp.router Kullanımı ---
    return MaterialApp.router(
      // --- GoRouter Yapılandırması ---
      routerConfig: _router, // Yukarıda tanımlanan _router değişkeni
      // --- Diğer MaterialApp Ayarları ---
      debugShowCheckedModeBanner: false,
      title: 'KTUN E-Commerce',
      theme: AppTheme.lightTheme,

      // --- ESKİ initialRoute ve routes KALDIRILDI ---
    );
  }
}
