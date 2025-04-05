import 'package:flutter/material.dart';
import 'package:project/widgets/sign_in_overlay.dart';
import 'package:project/widgets/sign_in_button.dart';
import 'package:project/widgets/favorite_button.dart'; // <-- YENİ İMPORT
import 'package:project/widgets/cart_button.dart'; // <-- YENİ İMPORT (Bu dosyanın var olduğunu varsayıyoruz)
import 'package:project/screens/cart/cart_page.dart'; // Import the cart page
import 'package:go_router/go_router.dart'; // GoRouter importu

class Header extends StatefulWidget {
  const Header({super.key});

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  bool _isSignInOpen = false;
  // bool _isHoveringSignIn = false; // SignInButton kendi hover state'ini yönetiyor
  final bool _isHoveringFavorites = false;
  final bool _isHoveringCart = false;

  // SignInButton ve Overlay arasındaki bağlantı için LayerLink
  final LayerLink _layerLink = LayerLink();

  // OverlayEntry oluşturmak için bir değişken
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    // Widget dispose edildiğinde overlay'i temizle
    _removeOverlay();
    super.dispose();
  }

  // Overlay'i gösterme fonksiyonu
  void _showSignInOverlay() {
    // Önce mevcut bir overlay varsa kaldır
    _removeOverlay();

    // Overlay'i tüm ekranın en üstünde göster
    _overlayEntry = OverlayEntry(
      builder:
          (context) => SignInOverlay(
            isOpen: true,
            onClose: () {
              _removeOverlay();
              setState(() {
                _isSignInOpen = false;
              });
            },
          ),
    );

    // Overlay'i ekle
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isSignInOpen = true;
    });
  }

  // Overlay'i kaldırma fonksiyonu
  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      width: double.infinity,
      // Header'ın arka plan rengini isterseniz buradan ayarlayabilirsiniz
      // color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Dikeyde başlangıçta hizala
            children: [
              // --- Sol Bölüm: Logo ve Branding ---
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(82, 99, 255, 1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      tooltip: 'Ana Sayfa', // Erişilebilirlik için
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 28,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Ana sayfaya yönlendirme
                        context.go('/'); // GoRouter ile değiştirildi
                      },
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Branding text (logonun altına konumlandırıldı)
                  SizedBox(
                    width: 220, // Genişliği ayarlayabilirsiniz
                    child: Text(
                      "Atalay's store management platform",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        fontFamily:
                            'Raleway', // Fontu projenize eklediğinizden emin olun
                        color: Colors.grey[800],
                      ),
                      maxLines: 2, // İki satıra kadar izin ver
                      overflow: TextOverflow.ellipsis, // Sığmazsa ... ile bitir
                    ),
                  ),
                ],
              ),

              const SizedBox(
                width: 16,
              ), // Logo/Branding ile Arama çubuğu arası boşluk
              // --- Orta Bölüm: Arama Çubuğu ---
              Expanded(
                flex: 3, // Arama çubuğunun esnek genişlik oranı
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for product, category or brand',
                      hintStyle: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                        size: 22,
                      ),
                      border: InputBorder.none, // Çerçeveyi kaldırır
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14, // Dikey hizalama için padding
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 40,
              ), // Arama çubuğu ve sağ butonlar arası boşluk
              // --- Sağ Bölüm: Aksiyon Butonları ---
              Row(
                mainAxisSize: MainAxisSize.min, // Butonlar kadar yer kapla
                children: [
                  // SignInButton - CompositedTransformTarget ile sarmak
                  CompositedTransformTarget(
                    link: _layerLink, // LayerLink'i burada kullan
                    child: SignInButton(
                      onTap: _showSignInOverlay,
                      isSelected: _isSignInOpen,
                    ),
                  ),

                  const SizedBox(width: 30), // Butonlar arası boşluk
                  // Favorites Button (ÖZEL WIDGET KULLANILARAK)
                  FavoriteButton(
                    // <-- MouseRegion/GestureDetector yerine direkt widget
                    onTap: () {
                      // Favoriler sayfasına gitme işlemi
                      print("Favorites Tapped!"); // Örnek eylem
                      context.go('/favorites'); // GoRouter ile değiştirildi
                    },
                    // isSelected: false, // Gerekirse bu parametreyi kullanabilirsiniz
                  ),

                  const SizedBox(width: 30), // Butonlar arası boşluk
                  // Cart Button (ÖZEL WIDGET KULLANILARAK - var olduğunu varsayıyoruz)
                  CartButton(
                    // <-- MouseRegion/GestureDetector yerine direkt widget
                    onTap: () {
                      // Sepet sayfasına gitme işlemi
                      print("Cart Tapped!"); // Debugging için
                      context.go('/cart'); // GoRouter ile değiştirildi
                    },
                    // isSelected: false, // Gerekirse bu parametreyi kullanabilirsiniz
                  ),
                ],
              ), // Sağ Buton Grubu Row Sonu

              const Spacer(), // Kalan tüm boşluğu doldurur
            ], // Ana Row Çocukları Sonu
          ),
        ], // Ana Column Çocukları Sonu
      ),
    );
  }
}

// --- ÖNEMLİ ---
// CartButton.dart dosyasının da FavoriteButton.dart'a benzer şekilde
// oluşturulmuş olması gerektiğini varsayıyoruz. Örnek bir CartButton yapısı:
/*
import 'package:flutter/material.dart';
// Gerekli ikonları import et
// import 'package:project/components/icons/cart_icon.dart';
// import 'package:project/components/icons/cart_hover_icon.dart';

class CartButton extends StatefulWidget {
  final VoidCallback? onTap;
  final bool isSelected;

  const CartButton({super.key, this.onTap, this.isSelected = false});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    // FavoriteButton'a benzer bir yapı kurun
    // Farklı renkler, ikonlar ve metin kullanın
    return InkWell(
      onTap: widget.onTap,
      onHover: (hovering) {
        setState(() {
          _isHovering = hovering;
        });
      },
      borderRadius: BorderRadius.circular(12), // Köşe yuvarlaklığı
      child: Container(
        width: 162, // Genişlik (FavoriteButton ile aynı veya farklı olabilir)
        height: 58, // Yükseklik (FavoriteButton ile aynı veya farklı olabilir)
        decoration: BoxDecoration(
          color: _isHovering ? Colors.grey[400] : Colors.grey[300], // Örnek renkler
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // İkonlar (kendi ikonlarınızı kullanın)
            // _isHovering ? CartHoverIcon(...) : CartIcon(...),
            Icon(Icons.shopping_cart, color: _isHovering ? Colors.blue : Colors.black), // Örnek ikon
            const SizedBox(width: 8),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: TextStyle(
                fontSize: _isHovering ? 26 : 20,
                color: _isHovering ? Colors.blue : Colors.black, // Örnek renkler
                fontWeight: FontWeight.w500,
              ),
              child: const Text("My Cart"),
            ),
          ],
        ),
      ),
    );
  }
}
*/
