import 'package:flutter/material.dart';
import 'package:project/components/icons/cart.dart'; // İkon importlarını kontrol et
import 'package:project/components/icons/my_reviews.dart';
import 'package:project/components/icons/coupon.dart';
import 'package:project/components/icons/stores.dart';
import 'package:project/components/icons/user_inf_sidebar.dart';
import 'package:project/components/icons/address.dart';
import 'package:project/components/icons/favorite_sidebar.dart';
import 'package:project/components/icons/ktun_gpt.dart';
import 'package:project/screens/address/address.dart';
import 'package:project/screens/cart/cart_page.dart';
import 'package:project/screens/favorites/favorites_page.dart';
import 'package:project/screens/user_info/user_info_page.dart';

// Define colors (Web kodundan alınanlar ve mevcutlar)
const Color sidebarBg = Color(0xFFF8F8F8);
const Color sectionBg = Colors.white; // Web'deki beyaz kutu
const Color hoverColor = Color(0xFFFFE8D6);
const Color activeColor = Color(0xFF00EEFF);
const Color dividerColor = Colors.red; // Web'de red-500 kullanılmış
const Color ktunGptBg = Color.fromRGBO(225, 255, 0, 0.5);
const Color ktunGptText = Color(0xFF4000FF);
const Color defaultTextColor = Colors.black;
const String ralewayFont = 'Raleway';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    // Mevcut rotayı almak için daha güvenilir yöntem (Eğer MaterialApp kullanıyorsanız)
    final String? currentPath = ModalRoute.of(context)?.settings.name;

    // Tıklanabilir menü öğesi oluşturan yardımcı fonksiyon
    Widget buildClickableItem({
      required Widget icon,
      required String text,
      required String routeName,
      required String? currentPath,
      double iconWidth = 40.0, // İkon alanı genişliği
      double? iconActualWidth, // İkonun kendi genişliği (opsiyonel)
      double? iconActualHeight, // İkonun kendi yüksekliği (opsiyonel)
      EdgeInsets padding = const EdgeInsets.symmetric(
        vertical: 8.0,
        horizontal: 12.0,
      ), // Padding ayarı
    }) {
      final bool isActive = currentPath == routeName;

      // İkonu boyutlandırmak için bir sarmalayıcı
      Widget sizedIcon = SizedBox(
        width: iconWidth, // Konteyner genişliği
        child: Align(
          alignment: Alignment.centerLeft, // İkonu sola yasla
          child:
              icon, // İkonun kendisi (boyutları kendi içinde ayarlı olabilir)
        ),
      );
      // Eğer özel boyutlar verilmişse, ikonu tekrar boyutlandır
      if (iconActualWidth != null || iconActualHeight != null) {
        if (icon is Icon) {
          // Eğer standart Icon ise size ile boyutlandır
          sizedIcon = SizedBox(
            width: iconWidth,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                (icon as Icon).icon,
                size: iconActualWidth ?? 24,
                color: (icon as Icon).color,
              ),
            ),
          );
        }
        // Özel ikon widget'ları için (CartMainIcon, MyReviewsIcon vb.) width/height parametrelerini kullanabiliriz
        // Ancak bu ikonlar zaten kendi boyutlarını alıyor, gerekirse burada tekrar set edilebilir.
      }

      return Material(
        // Arka plan rengini durumuna göre ayarla ve tam genişlik kaplasın
        color:
            isActive ? activeColor : sectionBg, // Aktifse mavi, değilse beyaz
        borderRadius: BorderRadius.circular(4),
        // Hover efekti ve tıklama için InkWell
        child: InkWell(
          onTap: () {
            // Aktif değilse ve rota farklıysa sayfaya git
            if (!isActive &&
                ModalRoute.of(context)?.settings.name != routeName) {
              Navigator.pushNamed(context, routeName);
            }
          },
          hoverColor: hoverColor, // Fare üzerine gelince renk
          borderRadius: BorderRadius.circular(4),
          child: Container(
            width: double.infinity, // Tam genişlik
            padding: padding, // İç boşluk
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Sola hizala
              children: [
                sizedIcon, // Boyutlandırılmış ikon alanı
                const SizedBox(width: 8.0), // İkon ve yazı arası boşluk
                // Yazının taşmasını önle ve sola yasla
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontFamily: ralewayFont,
                      fontSize: 20.0,
                      color:
                          isActive
                              ? Colors.white
                              : defaultTextColor, // Aktifse beyaz yazı
                    ),
                    overflow: TextOverflow.ellipsis, // Taşarsa ... ile bitir
                    maxLines: 1, // Tek satır
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Sidebar bölümlerini oluşturan yardımcı fonksiyon
    Widget buildSection({required String title, required List<Widget> items}) {
      return Container(
        width: 250,
        margin: const EdgeInsets.only(bottom: 36.0), // Alt boşluk korunuyor
        // Padding'i kaldırıyoruz, içeride yöneteceğiz
        decoration: BoxDecoration(
          color: sectionBg,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Başlığa padding verelim
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16.0,
                16.0,
                16.0,
                16.0,
              ), // Sol, Üst, Sağ, Alt
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: ralewayFont,
                  fontSize: 24.0,
                  color: defaultTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Ayırıcı çizgi - tam genişlikte
            Container(height: 1.0, color: dividerColor, width: double.infinity),
            const SizedBox(height: 8.0), // Çizgi ile item'lar arası boşluk
            // Öğeler listesi - tam genişlik kaplayacak
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 4.0,
              ), // Yan ve öğe arası boşluk
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children:
                    items
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: item,
                          ),
                        )
                        .toList(),
              ),
            ),
          ],
        ),
      );
    }

    // Ana Sidebar widget'ı
    return Positioned(
      // Web'deki absolute position değerleri
      left: 47.0,
      top: 55.0,
      child: Container(
        width: 300.0, // Web'deki w-[300px]
        height: 880.0, // Web'deki h-[880px] (Belki daha dinamik olmalı?)
        color: sidebarBg, // Arka plan bg-[#f8f8f8]
        // Padding ve margin değerleri web'den alındı
        padding: const EdgeInsets.only(
          top: 15.0,
          right: 16.0,
          bottom: 47.0,
          left: 24.0,
        ),
        // İçeriğin kaydırılabilir olması için
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // "My Orders" Bölümü
              buildSection(
                title: "My Orders",
                items: [
                  buildClickableItem(
                    // İkon boyutları web'den alındı
                    icon: const CartMainIcon(width: 48, height: 34),
                    text: "My cart",
                    routeName:
                        CartPage.routeName, // '/cart' yerine sabit kullanıldı
                    currentPath: currentPath,
                    iconActualWidth: 48, // Prop olarak geçilen değerler
                    iconActualHeight: 34,
                  ),
                  buildClickableItem(
                    // İkon boyutları web'den alındı
                    icon: const MyReviewsIcon(width: 50, height: 38),
                    text: "My reviews",
                    routeName: '/my-reviews', // Rota adını tanımla
                    currentPath: currentPath,
                    iconActualWidth: 50,
                    iconActualHeight: 38,
                  ),
                ],
              ),
              // "Special for you" Bölümü
              buildSection(
                title: "Special for you",
                items: [
                  buildClickableItem(
                    icon: const CouponIcon(width: 37, height: 37),
                    text: "My discount coupons",
                    routeName: '/discount-coupons', // Rota adını tanımla
                    currentPath: currentPath,
                    iconActualWidth: 37,
                    iconActualHeight: 37,
                  ),
                  buildClickableItem(
                    icon: const StoresIcon(width: 37, height: 37),
                    text: "My followed stores",
                    routeName: '/my-followed-stores', // Rota adını tanımla
                    currentPath: currentPath,
                    iconActualWidth: 37,
                    iconActualHeight: 37,
                  ),
                ],
              ),
              // "My Account" Bölümü
              buildSection(
                title: "My Account",
                items: [
                  buildClickableItem(
                    icon: const UserInfSidebarIcon(width: 37, height: 37),
                    text: "My user information",
                    routeName: UserInfoPage.routeName, // Rota adını tanımla
                    currentPath: currentPath,
                    iconActualWidth: 37,
                    iconActualHeight: 37,
                  ),
                  buildClickableItem(
                    // AddressIcon'a renk prop'u varsa kullanıldı
                    icon: const AddressIcon(
                      width: 37,
                      height: 37,
                      color: defaultTextColor,
                    ),
                    text: "My address information",
                    routeName: AddAddressPage.routeName, // Rota adını tanımla
                    currentPath: currentPath,
                    iconActualWidth: 37,
                    iconActualHeight: 37,
                  ),
                  buildClickableItem(
                    icon: const FavoriteSidebarIcon(width: 37, height: 37),
                    text: "My favorites",
                    routeName: FavoritesPage.routeName, // Rota adını tanımla
                    currentPath: currentPath,
                    iconActualWidth: 37,
                    iconActualHeight: 37,
                  ),
                ],
              ),
              // KTUNGpt Bölümü
              Container(
                width: 260.0, // Web'deki w-[260px]
                margin: const EdgeInsets.only(top: 20.0), // mt-[20px]
                padding: const EdgeInsets.fromLTRB(
                  6,
                  5,
                  2,
                  35,
                ), // p-[5px_2px_35px_6px]
                decoration: BoxDecoration(
                  color: ktunGptBg, // backgroundColor: 'rgba(225, 255, 0, 0.5)'
                  borderRadius: BorderRadius.circular(8.0), // rounded-lg
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // İkon rengi style'dan alındı
                        const KtunGptIcon(
                          width: 50.0,
                          height: 50.0,
                          color: ktunGptText,
                        ),
                        const SizedBox(width: 8.0), // gap-2
                        // Yazının taşmaması için Expanded
                        const Expanded(
                          child: Text(
                            "Ask to KTUNGpt",
                            style: TextStyle(
                              fontFamily: ralewayFont,
                              fontSize: 26.0, // text-[26px]
                              color: ktunGptText, // text-[#4000FF]
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0), // mt-6 (yaklaşık)
                    const Text(
                      "I'm always Here! I answer your questions immediately!",
                      style: TextStyle(
                        fontFamily: ralewayFont,
                        fontSize: 16.0, // text-[16px]
                        color: defaultTextColor,
                        height: 1.2, // leading-tight
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
