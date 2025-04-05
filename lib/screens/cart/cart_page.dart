import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:project/providers/cart_provider.dart';
import 'package:project/widgets/product_cart_item.dart';
import 'package:project/widgets/cart_summary.dart';
import 'package:project/widgets/coupon_overlay.dart';
import 'package:project/widgets/sidebar/siderbar.dart';
import 'package:project/components/icons/coupon.dart';
import 'package:project/components/icons/arrow_right.dart';
import 'package:project/components/icons/bin.dart';
import 'package:project/components/messages/my_cart_message.dart'; // Gerekliyse import
import 'package:project/components/messages/complete_shopping_message.dart'; // Gerekliyse import
import 'package:project/screens/payment/payment_page.dart'; // PaymentPage importu

// Define colors and fonts
const Color couponBarBg = Color(0xFFD9D9D9); // #D9D9D9
const Color couponTextColor = Color(0xFFFF9D00); // #FF9D00
const Color deleteTextColor = Color(
  0xFFFFF600,
); // #FFF600 (Web'de #FFF600 idi, #FFFF00 değil)

const String ralewayFont = 'Raleway';
const String redHatDisplayFont = 'RedHatDisplay'; // CartSummary'de kullanılıyor

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // --- Build Undo/Complete Shopping Messages (Mevcut kod korundu) ---
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ... (Snackbar ve Dialog gösterme kodları) ...
    });

    // Web layout constants (Sidebar ve içerik arası boşlukları hesaba kat)
    const double sidebarWidth = 300.0;
    const double sidebarMargin = 23.0 + 34.0; // Sol + Sağ margin
    const double sidebarLeftPos = 47.0;
    const double contentStartMargin =
        20.0; // Sidebar ile içerik arasındaki boşluk
    const double contentStartX =
        sidebarLeftPos +
        sidebarWidth +
        contentStartMargin; // İçeriğin başlangıç X konumu
    const double mainContentAreaWidth = 800.0; // Web'deki ana içerik genişliği
    const double cartSummaryWidth = 255.0;
    const double cartSummaryRightMargin = 372.0; // Sağdan boşluk

    // Sayfa başlığı ve silme butonu için sabit konumlar (Web'den alındı)
    const double headerTopPos =
        142.0; // Web'deki top: 87 (appbar?) + 55 (sidebar top) ? Yaklaşık değer.
    const double deleteButtonLeftPos = 983.0; // Web'den alındı
    const double deleteButtonTopPos = 179.0; // Web'den alındı

    // Kupon barı için sabit konum (Web'den alındı)
    const double couponBarTopPos = 225.0;

    // Ürün listesi için başlangıç Y konumu
    const double productListTopMargin = 100.0;
    final double productListStartY =
        couponBarTopPos + 80 + 20; // Kupon barı + yüksekliği + alt boşluk

    // Özet kutusu için Y konumu (Web'den alındı)
    const double summaryTopPos = 205.0;

    return Scaffold(
      backgroundColor:
          Colors
              .white, // Sayfa arka planı (Web'de belirtilmemiş ama genelde beyaz)
      body: Stack(
        children: [
          // Sidebar
          const Sidebar(),

          // MAIN CONTENT AREA
          Positioned(
            left: contentStartX,
            top: headerTopPos,
            child: SizedBox(
              // Ana içeriği sarmalayan SizedBox (Genişlik için)
              width: mainContentAreaWidth,
              child: Column(
                // İçerikleri alt alta sırala
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- Header (Alan 2) ---
                  SizedBox(
                    // Başlık için alan
                    width: mainContentAreaWidth, // Row genişliği doldursun
                    child: Text(
                      "My cart (${cartState.products.length} product${cartState.products.length != 1 ? 's' : ''})",
                      style: const TextStyle(
                        fontFamily: ralewayFont,
                        fontSize: 64.0, // text-[64px]
                        fontWeight: FontWeight.normal, // font-normal
                      ),
                    ),
                  ),
                  // Web'deki gibi SİLME BUTONU buraya Positioned ile eklenebilir
                  // Veya başlık Row içinde Spacer ile sağa yaslanabilir.
                  // Şimdilik Row içinde bırakalım, gerekirse Positioned yaparız.
                  // const SizedBox(height: 24), // Başlık ile kupon barı arasına boşluk

                  // --- Coupon Bar (Alan 3) ---
                  // Positioned ile yerleştirmek yerine Column içinde bırakıyoruz,
                  // product listesi buna göre ayarlanacak.
                  Container(
                    margin: const EdgeInsets.only(
                      top: 24,
                    ), // Başlıktan sonra boşluk
                    width: mainContentAreaWidth, // w-[800px]
                    height: 80, // h-[80px]
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                    ), // px-6
                    decoration: BoxDecoration(
                      color: couponBarBg, // bg-[#D9D9D9]
                      borderRadius: BorderRadius.circular(8.0), // rounded-lg
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Sol taraf: İkon, Yazı, Ok
                        InkWell(
                          // Kuponlarım kısmını tıklanabilir yapalım
                          onTap: () {
                            // Kuponlarım sayfasına gitme veya modal açma
                            print("My coupons tıklandı");
                          },
                          child: Row(
                            children: [
                              CouponIcon(
                                width: 32,
                                height: 32,
                                color: couponTextColor,
                              ),
                              const SizedBox(width: 16), // gap-4
                              const Text(
                                "My coupons",
                                style: TextStyle(
                                  fontFamily: ralewayFont,
                                  fontSize: 32, // text-[32px]
                                  color: couponTextColor,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const ArrowRightIcon(
                                width: 32,
                                height: 32,
                                color: couponTextColor,
                              ), // Rengi ekledik
                            ],
                          ),
                        ),
                        // Sağ taraf: Kupon kodu ekle
                        InkWell(
                          onTap: () => cartNotifier.showCouponOverlay(true),
                          child: const Text(
                            "Add coupon code +",
                            style: TextStyle(
                              fontFamily: ralewayFont,
                              fontSize: 32, // text-[32px]
                              color: couponTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ), // Kupon barı ile liste arası boşluk
                  // --- Products List (Alan 4) ---
                  SizedBox(
                    // Yüksekliği ekran yüksekliğinden hesaplayalım (dinamik)
                    // headerTopPos + başlık yüksekliği + kupon barı + boşluklar çıkarılır
                    height:
                        screenHeight -
                        headerTopPos -
                        80 -
                        80 -
                        24 -
                        20 -
                        40, // Yaklaşık hesap
                    width: mainContentAreaWidth,
                    child: ListView.builder(
                      // Çok sayıda ürün olabileceği için ListView.builder daha iyi
                      padding: EdgeInsets.zero, // Ekstra padding olmasın
                      itemCount:
                          cartState.products.length == 0
                              ? 1
                              : cartState.products.length,
                      itemBuilder: (context, index) {
                        if (cartState.products.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.only(top: 32.0),
                            child: Center(
                              child: Text(
                                "Your cart is empty",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }
                        final product = cartState.products[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0), // mb-4
                          child: ProductCartItem(
                            product: product,
                            isSelected: cartState.selectedProducts.contains(
                              product.id,
                            ),
                            onCheckboxChanged:
                                (value) => cartNotifier.toggleProductSelection(
                                  product.id,
                                ),
                            onQuantityChanged:
                                (change) => cartNotifier.changeQuantity(
                                  product.id,
                                  change,
                                ),
                            onRemove:
                                () => cartNotifier.removeProduct(product.id),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- Delete Products Button (Positioned) ---
          Positioned(
            left: deleteButtonLeftPos,
            top: deleteButtonTopPos,
            child: InkWell(
              onTap:
                  cartState.products.isEmpty
                      ? null
                      : () =>
                          cartNotifier
                              .removeAllProducts(), // TODO: Undo for all
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Delete products",
                    style: TextStyle(
                      color: deleteTextColor, // #FFF600
                      fontFamily: ralewayFont,
                      fontSize: 24, // text-[24px]
                    ),
                  ),
                  const SizedBox(width: 8), // gap-2
                  const BinIcon(
                    width: 24,
                    height: 24,
                    color: deleteTextColor, // Renk eklendi
                  ),
                ],
              ),
            ),
          ),

          // --- Selected Products Summary (Alan 5) ---
          Positioned(
            // Web'deki right ve top değerleri
            right: cartSummaryRightMargin,
            top: summaryTopPos,
            child: CartSummary(
              selectedCount: cartState.selectedProducts.length,
              selectedTotalPrice: cartState.selectedTotalPrice,
              onCompleteShopping: () {
                if (cartState.selectedProducts.isEmpty) {
                  cartNotifier.showCompleteShoppingMessage(true);
                } else {
                  // Ödeme sayfasına yönlendir (routeName ile)
                  context.go(PaymentPage.routeName);
                }
              },
            ),
          ),

          // --- Messages & Overlays (Mevcut kod korundu) ---
          // ... (MyCartMessage, CompleteShoppingMessage, CouponOverlay Positioned widgetları) ...
          // Messages - MyCartMessage
          if (cartState.showUndoMessage)
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                // Ortalamak için Center eklendi
                // MyCartMessage'in kendi içinde bir genişliği ve stili olmalı
                child: MyCartMessage(
                  itemCount: 1, // veya silinen ürün sayısı
                  total: cartState.lastRemovedProduct?.price ?? 0,
                  onViewCart:
                      () =>
                          cartNotifier
                              .dismissUndoMessage(), // Bu butonun amacı farklı olabilir
                  onCheckout:
                      () => cartNotifier.undoRemove(), // Bu 'UNDO' olmalı
                ),
              ),
            ),

          // CompleteShoppingMessage
          if (cartState.showCompleteShoppingMessage)
            Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(
                // Ortalamak için Center eklendi
                child: CompleteShoppingMessage(
                  message: "Please select products before completing shopping.",
                  onClose:
                      () => cartNotifier.showCompleteShoppingMessage(false),
                  // onComplete: null, // Bu butona gerek var mı?
                ),
              ),
            ),

          // Coupon Overlay
          if (cartState.showCouponOverlay)
            Positioned.fill(
              // Tüm ekranı kapla
              child: Stack(
                children: [
                  // Arka plan karartıcı
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () => cartNotifier.showCouponOverlay(false),
                      child: Container(
                        color: Colors.black.withOpacity(0.3),
                      ), // Web'deki black/30
                    ),
                  ),
                  // Kupon içeriği (Web'deki gibi sağ üstte)
                  Positioned(
                    top: 16.0, // mt-4
                    right: 16.0, // mr-4
                    child: CouponOverlay(
                      // CouponOverlay widget'ının boyutları kendi içinde ayarlı olmalı
                      coupons: cartState.currentCoupons,
                      searchTerm: cartState.couponSearchTerm,
                      currentPage: cartState.couponCurrentPage,
                      totalPages: cartState.totalCouponPages,
                      onClose: () => cartNotifier.showCouponOverlay(false),
                      onSearchChanged: cartNotifier.setCouponSearchTerm,
                      onPageChanged: cartNotifier.changeCouponPage,
                      onUseCoupon: (coupon) {
                        print("Using coupon: ${coupon.code}");
                        // TODO: Kupon uygulama mantığı
                        cartNotifier.showCouponOverlay(false);
                      },
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
